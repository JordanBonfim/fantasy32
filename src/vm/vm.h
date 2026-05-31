

// void VM_init(VM *vm);
// void VM_load(VM *vm, char *arqBin);
// void VM_runInstr(VM *vm);

#pragma once
#include <stdint.h>

#define S_MEM (16 * 1024 * 1024)
#define SP 14
#define PC 15

class VM {
private:
  int32_t regs[16];
  uint8_t *mem;
  // start and end of the video memory
  uint32_t videoMemStart = 0x00FB4000;
  uint32_t videoMemEnd = 0x00FFEFFF;
  // screen dimensions
  uint32_t w = 320;
  uint32_t h = 240;
  uint32_t readMem(uint32_t addr);
  bool writeMem(uint32_t addr, uint32_t value);
  void execTypeR(uint32_t instr, uint32_t opcode);
  void execTypeI(uint32_t instr, uint32_t opcode);
  void execTypeJ(uint32_t instr, uint32_t opcode);
  void execTypeU(uint32_t instr, uint32_t opcode);
  void execTypeS(uint32_t instr, uint32_t opcode);

public:
  VM();
  ~VM();
  void load(char *arqBin);
  void run();
  bool runInstr();
};
