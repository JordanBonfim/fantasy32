#include "vm/vm.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  char *programPath = (argc >= 2) ? argv[1] : (char *)"src/assembler/prog1.bin";

  VM vm;
  vm.load(programPath);
  while (vm.isRunning()) {
    vm.run();
  }
  
  return 0;
}
