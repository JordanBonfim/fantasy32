#include "vm.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Opcodes named as an enum to avoid many #defines
enum Opcode {
  MOVL = 0x0D,

};

void VM_init(VM *vm) {
  vm->mem = malloc(sizeof(uint8_t) * S_MEM);
  memset(vm->mem, 0, S_MEM * sizeof(uint8_t));
  memset(vm->regs, 0, 16 * sizeof(int32_t));
}

void VM_load(VM *vm, char *arqBin) {
  FILE *bin = fopen(arqBin, "rb");
  fseek(bin, 0, SEEK_END);
  int binSize = ftell(bin) - sizeof(uint32_t);
  rewind(bin);

  uint32_t codeStart;
  fread(&codeStart, sizeof(uint32_t), 1, bin);
  codeStart = __builtin_bswap32(codeStart);
  fread(vm->mem, 1, binSize, bin);
  vm->regs[PC] = codeStart;

  fclose(bin);
}

uint32_t readMem(VM *vm, uint32_t addr) {
  return (vm->mem[addr] << 24) | (vm->mem[addr + 1] << 16) |
         (vm->mem[addr + 2] << 8) | vm->mem[addr + 3];
}

void VM_runInstruction(VM *vm) {
  int32_t pc = vm->regs[PC];
  uint32_t instr = readMem(vm, pc);
  uint32_t opcode = instr >> 26;

  uint32_t i_rs = (instr >> 22) & 0xF;
  uint32_t i_rt = (instr >> 18) & 0xF;
  uint32_t i_imm = instr & 0x3FFFF;

  vm->regs[PC] += 4; // Increment PC to point to the next instruction

  switch (opcode) {
  case MOVL: {
    vm->regs[i_rt] = (i_imm & 0xFFFF);
    break;
  }
  default:
    printf("Unknown opcode: 0x%X\n", opcode);
    exit(1);
  }}