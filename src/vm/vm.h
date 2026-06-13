#pragma once
#include "keyboard.h"
#include <stdint.h>

#define S_MEM (16 * 1024 * 1024)
#define SP 14
#define PC 15
struct AudioState;
class VM {
private:
  // running state
  bool running = true;
  uint32_t sleepUntil = 0;
  uint32_t frame_number = 0;

  int32_t regs[16];
  uint8_t *mem;
  // start and end of the video memory
  uint32_t videoMemStart = 0x00FB4000;
  uint32_t videoMemEnd = 0x00FFEFFF;

  uint8_t FPS = 60;
  uint32_t readMem(uint32_t addr);
  bool writeMem(uint32_t addr, uint32_t value);
  void execTypeR(uint32_t instr, uint32_t opcode);
  void execTypeI(uint32_t instr, uint32_t opcode);
  void execTypeJ(uint32_t instr, uint32_t opcode);
  void execTypeU(uint32_t instr, uint32_t opcode);
  void execTypeS(uint32_t instr, uint32_t opcode);

  // IO
  Keyboard keyboard;

  // screen dimensions
  uint32_t w = 320;
  uint32_t h = 240;

  SDL_Window *window = nullptr;
  SDL_Renderer *renderer = nullptr;
  SDL_Texture *texture = nullptr;
  int scale = 3; // Fator de escala padrão

  // AUDIO
  AudioState *m_audio = nullptr;

public:
  VM();
  ~VM();
  bool isRunning() const { return running; }
  void load(char *arqBin);
  void run();
  void runInstr() __attribute__((hot));
  void render();
  void printRegs();
  void initGraphics(int windowScale);
  uint32_t getWidth() const { return w; };
  uint32_t getHeight() const { return h; };
  void incFrameNumber() { frame_number += 1; };
  uint32_t getFrameNumber() { return frame_number; };
  void attachAudio(AudioState *audioState) { m_audio = audioState; }
};
