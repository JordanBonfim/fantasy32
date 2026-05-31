

// void VM_init(VM *vm);
// void VM_load(VM *vm, char *arqBin);
// void VM_runInstr(VM *vm);

#pragma once
#include <stdint.h>

#define S_MEM 1024
#define SP 14
#define PC 15


class VM {
private:
  int32_t regs[16];
  uint8_t *mem;
  uint32_t readMem(uint32_t addr);
  bool writeMem(uint32_t addr, uint32_t value);
  void decode(uint32_t instr, uint32_t op, uint32_t &rs, uint32_t &rt, uint32_t &rd, uint32_t &imm, int32_t &offset, uint32_t &addr);

public:
  VM();
  ~VM();
  void load(char *arqBin);
  void runInstr() __attribute__((hot));
};
