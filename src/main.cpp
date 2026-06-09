#include "vm/vm.h"
#include <stdio.h>
#include <stdlib.h>
#include "audio.h"
#include <miniaudio.h>

int main(int argc, char **argv) {
  ma_device device;
  AudioState audioState = {0.0f, 0, 0, 0}; // silence start
  if(!start_miniaudio(&device, &audioState)){printf("Erro ao iniciar miniaudio"); return -1;}

  char *programPath = (argc >= 2) ? argv[1] : (char *)"src/assembler/prog1.bin";
  
  VM vm;
  vm.load(programPath);
  vm.attachAudio(&audioState);
  while (vm.isRunning()) {
    vm.run();
  }
  finish_miniaudio(&device);
  
  return 0;
}
