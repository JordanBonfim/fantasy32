#include <stdint.h>

typedef struct VM {
    int32_t regs[16];
    uint8_t *mem;
} VM;

#define PC 15
#define SP 14

#define S_MEM 1024

void VM_init(VM *vm);
void VM_load(VM *vm, char *arqBin);
void VM_runInstruction(VM *vm);