#include "vm.h"
#include "../util/util.cpp"
#include "opcodes.h"
#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "font.h"
#include <string>
#include <miniaudio.h>

#include <atomic>
struct AudioState {
    std::atomic<float> frequency;
    std::atomic<int> duration;
    std::atomic<int> waveForm;
    std::atomic<double> phase;
};

VM::VM() {
  this->mem = new uint8_t[S_MEM];
  this->halted = false;
  memset(this->mem, 0, S_MEM * sizeof(uint8_t));
  memset(this->regs, 0, 16 * sizeof(int32_t));
  this->regs[SP] = 0x00FFFFFF; // Stack Pointer starts at the end of memory

  // Usando o sdl para cria um janela, cria e criar uma textura, e nela
  // renderizar os pixels da memória de vídeo
  SDL_Init(SDL_INIT_VIDEO);
  window = SDL_CreateWindow("Fantasys32", SDL_WINDOWPOS_CENTERED,
                            SDL_WINDOWPOS_CENTERED, w * scale, h * scale,
                            SDL_WINDOW_SHOWN);
  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
  texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ARGB8888,
                              SDL_TEXTUREACCESS_STREAMING, w, h);
}

VM::~VM() { 
  delete[] this->mem; 
  if (texture) SDL_DestroyTexture(texture);
  if (renderer) SDL_DestroyRenderer(renderer);
  if (window) SDL_DestroyWindow(window);
  SDL_Quit();
}

uint32_t VM::readMem(uint32_t addr) {
  return (this->mem[addr] << 24) | (this->mem[addr + 1] << 16) |
         (this->mem[addr + 2] << 8) | this->mem[addr + 3];
}

bool VM::writeMem(uint32_t addr, uint32_t value) {
  if (addr + 3 >= S_MEM) {
    return false;
  }
  this->mem[addr] = (value >> 24) & 0xFF;
  this->mem[addr + 1] = (value >> 16) & 0xFF;
  this->mem[addr + 2] = (value >> 8) & 0xFF;
  this->mem[addr + 3] = value & 0xFF;
  return true;
}

void VM::load(char *arqBin) {
  FILE *bin = fopen(arqBin, "rb");
  fseek(bin, 0, SEEK_END);
  int binSize = ftell(bin) - sizeof(uint32_t);
  rewind(bin);

  uint32_t codeStart;
  fread(&codeStart, sizeof(uint32_t), 1, bin);
  codeStart = __builtin_bswap32(codeStart);
  fread(this->mem, 1, binSize, bin);
  this->regs[PC] = codeStart;

  fclose(bin);
}

void VM::runInstr() {
  uint32_t instr = readMem(this->regs[PC]);
  uint32_t opcode = instr >> 26;

  this->regs[PC] += 4;

  if (opcode <= 0x0B) {
    this->execTypeR(instr, opcode);
  } else if (opcode <= 0x16) {
    this->execTypeI(instr, opcode);
  } else if (opcode <= 0x18) {
    this->execTypeJ(instr, opcode);
  } else if (opcode <= 0x1E) {
    this->execTypeU(instr, opcode);
  } else if (opcode <= 0x2B) {
    this->execTypeS(instr, opcode);
  } else {
    printf("Unknown opcode: 0x%X\n", opcode);
    exit(1);
  }
}

void VM::run() {
  if (!this->running) {
    printf("Shutting down ZZZZZ.\n");
    return;
  }

  uint32_t sTime = SDL_GetTicks();

  // Processar Eventos (No nosso caso é basicamente o teclado)
  SDL_Event event;
  while (SDL_PollEvent(&event)) {
    if (event.type == SDL_QUIT) this->running = false;
    // Atualiza o estado interno do teclado da VM
    keyboard.handleEvent(event);
  }

  int instrsPerFrame = 1000; // Número de instruções a executar por frame 
  for (int i = 0; i < instrsPerFrame && this->running && !this->halted; i++) {
    runInstr();
  }

  this->render();

  // elapsed time since the start of the frame
  // frametime
  // o controle de tempo parece ser obrigatório para manter o 60 fps

  uint32_t eTime = SDL_GetTicks() - sTime;
  uint32_t fTime = 1000 / this->FPS; // Tempo ideal por frame em ms
  if (eTime < fTime) {
    SDL_Delay(fTime - eTime); // Aguarda o tempo restante para o próximo frame
    incFrameNumber();
  }
}

void VM::execTypeR(uint32_t instr, uint32_t opcode) {
  uint32_t i_rs = (instr >> 22) & 0xF;
  uint32_t i_rt = (instr >> 18) & 0xF;
  uint32_t i_rd = (instr >> 14) & 0xF;

  switch (opcode) {
  // Arithmetic and logical instructions (type R, except for ADDI)
  case ADD:
    this->regs[i_rd] = this->regs[i_rs] + this->regs[i_rt];
    break;
  case SUB:
    this->regs[i_rd] = this->regs[i_rs] - this->regs[i_rt];
    break;
  case MUL:
    this->regs[i_rd] = this->regs[i_rs] * this->regs[i_rt];
    break;
  case DIV:
    this->regs[i_rd] = this->regs[i_rs] / this->regs[i_rt];
    break;
  case MOD:
    this->regs[i_rd] = this->regs[i_rs] % this->regs[i_rt];
    break;
  case AND:
    this->regs[i_rd] = this->regs[i_rs] & this->regs[i_rt];
    break;
  case OR:
    this->regs[i_rd] = this->regs[i_rs] | this->regs[i_rt];
    break;
  case XOR:
    this->regs[i_rd] = this->regs[i_rs] ^ this->regs[i_rt];
    break;
  case SHL:
    this->regs[i_rd] = this->regs[i_rs] << (this->regs[i_rt] & 0x1F);
    break;
  case SHR:
    this->regs[i_rd] = this->regs[i_rs] >> (this->regs[i_rt] & 0x1F);
    break;
  case ROL:
    this->regs[i_rd] = (this->regs[i_rs] << (this->regs[i_rt] & 0x1F)) |
                       (this->regs[i_rs] >> (32 - (this->regs[i_rt] & 0x1F)));
    break;
  case ROR:
    this->regs[i_rd] = (this->regs[i_rs] >> (this->regs[i_rt] & 0x1F)) |
                       (this->regs[i_rs] << (32 - (this->regs[i_rt] & 0x1F)));
    break;
  default:
    printf("Unknown opcode: 0x%X\n", opcode);
    exit(1);
  }
}

void VM::execTypeI(uint32_t instr, uint32_t opcode) {
  int32_t &pc = this->regs[PC];

  uint32_t i_rs = (instr >> 22) & 0xF;
  uint32_t i_rt = (instr >> 18) & 0xF;
  uint32_t i_imm = instr & 0x3FFFF;
  int32_t offset = (int16_t)(i_imm & 0xFFFF); // Used for branch instructions,
                                              // allowing negative values

  switch (opcode) {
  case ADDI: // Type I
    this->regs[i_rt] = this->regs[i_rs] + (i_imm & 0xFFFF);
    break;

  // Memory movement instructions (type I)
  case MOVL:
    this->regs[i_rt] = (i_imm & 0xFFFF);
    break;
  case MOVH:
    this->regs[i_rt] = this->regs[i_rt] | (i_imm << 16);
    break;
  case LOAD: {
    uint32_t addr = this->regs[i_rs] + (i_imm * 4);
    if (!isInsideMem(addr)) {
      printf("Memory access out of bounds: 0x%X\n", addr);
      exit(1);
    }
    this->regs[i_rt] = readMem(addr);
    break;
  }
  case STORE: {
    uint32_t addr = this->regs[i_rs] + (i_imm * 4);
    if (!isInsideMem(addr)) {
      printf("Memory access out of bounds: 0x%X\n", addr);
      exit(1);
    }
    writeMem(addr, this->regs[i_rt]);
    break;
  }

  // BRANCH INSTRUCTIONS (type I)
  case BEQ:
    if (this->regs[i_rs] == regs[i_rt]) {
      pc += (offset * 4);
    }
    break;

  case BNE:
    if (this->regs[i_rs] != this->regs[i_rt]) {
      pc += (offset * 4);
    }
    break;

  case BLT:
    if (this->regs[i_rs] < this->regs[i_rt]) {
      pc += (offset * 4);
    }
    break;

  case BGT:
    if (this->regs[i_rs] > this->regs[i_rt]) {
      pc += (offset * 4);
    }
    break;

  case BLE:
    if (this->regs[i_rs] <= this->regs[i_rt]) {
      pc += (offset * 4);
    }
    break;

  case BGE:
    if (this->regs[i_rs] >= this->regs[i_rt]) {
      pc += (offset * 4);
    }
    break;
  default:
    printf("Unknown opcode: 0x%X\n", opcode);
    exit(1);
  }
}

void VM::execTypeJ(uint32_t instr, uint32_t opcode) {
  int32_t &pc = this->regs[PC];

  switch (opcode) {
  case JMP: {
    uint32_t target_addr26 = (instr & 0x03FFFFFF) << 2;
    if (!isInsideMem(target_addr26)) {
      printf("Invalid jump address: 0x%X\n", target_addr26);
      exit(1);
    }
    pc = target_addr26;
    break;
  }

  case CALL: {
    uint32_t target_addr26 = (instr & 0x03FFFFFF) << 2;
    if (!isInsideMem(target_addr26)) {
      printf("Invalid call address: 0x%X\n", target_addr26);
      exit(1);
    }
    if (this->regs[SP] <= 0x0FFEFFF) {
      printf("Stack Overflow\n");
      exit(1);
    }
    this->regs[SP] -= 4;
    writeMem(this->regs[SP], pc);
    pc = target_addr26;
    break;
  }
  default:
    printf("Unknown opcode: 0x%X\n", opcode);
    exit(1);
  }
}

void VM::execTypeU(uint32_t instr, uint32_t opcode) {
  uint32_t u_rd = (instr >> 22) & 0xF;

  switch (opcode) {
  case PUSH:
    if (this->regs[SP] <= 0x0FFEFFF) {
      printf("Stack Overflow\n");
      exit(1);
    }
    this->regs[SP] -= 4;
    writeMem(this->regs[SP], this->regs[u_rd]);
    break;

  case POP:
    if (this->regs[SP] >= 0x00FFFFFF) {
      printf("Stack Underflow\n");
      exit(1);
    }
    this->regs[u_rd] = readMem(this->regs[SP]);
    this->regs[SP] += 4;
    break;
  case INC:
    this->regs[u_rd]++;
    break;
  case DEC:
    this->regs[u_rd]--;
    break;
  case NOT:
    this->regs[u_rd] = ~this->regs[u_rd];
    break;
  case RET:
    if (this->regs[SP] >= 0x00FFFFFF) {
      printf("Stack Underflow\n");
      exit(1);
    }
    this->regs[PC] = readMem(this->regs[SP]);
    this->regs[SP] += 4;
    break;
  default:
    printf("Unknown opcode: 0x%X\n", opcode);
    exit(1);
  }
}

void VM::execTypeS(uint32_t instr, uint32_t opcode) {

  uint32_t i_ra = (instr >> 22) & 0xF;
  uint32_t i_rb = (instr >> 18) & 0xF;
  uint32_t i_rc = (instr >> 14) & 0xF;
  uint32_t i_rd = (instr >> 10) & 0xF;
  uint32_t i_re = (instr >> 6) & 0xF;

  uint32_t *base =
      reinterpret_cast<uint32_t *>(this->mem + this->videoMemStart);

  switch (opcode) {
  case RECT: {
    const uint32_t ra = this->regs[i_ra];
    const uint32_t rb = this->regs[i_rb];
    uint32_t rc = this->regs[i_rc];
    uint32_t rd = this->regs[i_rd];

    const uint32_t w = this->w;
    const uint32_t h = this->h;

    if (ra >= w || rb >= h) {
      printf("Invalid rectangle origin coordinates: (%u, %u)\n", ra, rb);
      exit(1);
    }

    // truncate width
    if (rc > w - ra) {
      rc = w - ra;
      this->regs[i_rc] = rc;
    }

    // truncate height
    if (rd > h - rb) {
      rd = h - rb;
      this->regs[i_rd] = rd;
    }
    for (uint32_t i = 0; i < rd; i++) {
      uint32_t *row = base + ((rb + i) * w + ra);
      for (uint32_t j = 0; j < rc; j++) {
        row[j] = this->regs[i_re];
      }
    }

    break;
  }

    case DSPRITE: {
      uint32_t x = this->regs[i_ra];
      uint32_t y = this->regs[i_rb];  
      uint32_t width = this->regs[i_rc];
      uint32_t height = this->regs[i_rd];
      uint32_t sprite_addr = this->regs[i_re];

      for (uint32_t row = 0; row < height; row++){
        for (uint32_t col = 0; col < width; col++){
          if((y+row) >= h || (x+col)>=w){
            continue;
          }
          uint32_t color = readMem(sprite_addr + ((row * width + col) * 4));
          base[(y+row) * w + (x+col)] = color;
        }        
      }
      break;
    }

  case CLEAR: {
    const uint32_t pixelCount = this->w * this->h;
    for (uint32_t i = 0; i < pixelCount; i++) {
      base[i] = this->regs[i_ra];
    }
    break;
  }

  case GKEY: {
    this->regs[i_ra] = keyboard.isKeyPressed(this->regs[i_rb]) ? 1 : 0;
    break;
  }

  case PLAY:{
    uint32_t freq = this->regs[i_ra];
    uint32_t ms = this->regs[i_rb];
    uint32_t wave_form = this->regs[i_rc];

    if(m_audio != nullptr){
      m_audio->frequency.store((float) freq);
      m_audio->waveForm.store(wave_form);
      m_audio->duration.store(ms*48);
  
    }
    break; 
  }

  case SLEEP: {
    uint32_t ms = this->regs[i_ra];
    SDL_Delay(ms);
    break;
  }

  case PSTR: {
    drawText(
      this->regs[i_ra], 
      this->regs[i_rb], 
      (char*)&this->mem[this->regs[i_rc]],
      this->regs[i_rd], 
      getWidth(), base);
    break;
  }

  case PINT: {
    std::string str = std::to_string(this->regs[i_rc]);
    const char* text = str.c_str();
    drawText(
      this->regs[i_ra], 
      this->regs[i_rb], 
      text,
      this->regs[i_rd], 
      getWidth(), base);
    break;
  }
  
  // case SYSCALL:
  //
  case SRAND: {
    srand(this->regs[i_ra]);
    break;
  }

  case RAND: {
    this->regs[i_ra] = rand() % this->regs[i_rb] + this->regs[i_rc];
    break;
  }
    
  case FRAMENUM:{
    this->regs[i_ra] = getFrameNumber();
    break;
  }
    
  case HALT: {
    this->halted = true;
    break;
  }
  default:
    printf("Unknown opcode: 0x%X\n", opcode);
    break;
    // exit(1);
  }
}

void VM::render() {
  uint8_t *pixelData = &mem[videoMemStart];

  SDL_UpdateTexture(texture, nullptr, pixelData, w * sizeof(uint32_t));

  SDL_RenderClear(renderer);

  SDL_RenderCopy(renderer, texture, nullptr, nullptr);

  SDL_RenderPresent(renderer);
}
void VM::printRegs() {
  printf("Registers:\n");
  for (int i = 0; i < 16; i++) {
    printf("R%d: 0x%08X\n", i, this->regs[i]);
  }
}