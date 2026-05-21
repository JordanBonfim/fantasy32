#include <stdio.h>
#include <stdlib.h>
#include "vm.h"


int main(int argc, char const *argv[])
{
  VM vm;
  VM_init(&vm);
  VM_load(&vm, "bin/test.bin");

  
  return 0;
}
