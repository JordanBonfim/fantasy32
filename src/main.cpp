#include "vm/vm.h"
#include <stdio.h>
#include <stdlib.h>
#include "audio.h"
#include <SDL2/SDL.h>

int main(int argc, char **argv) {

  if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO) < 0) {
      printf("Erro: Falha ao iniciar SDL2: %s\n", SDL_GetError());
      return -1;
  }

  AudioState audioState = {0.0f, 0, 0, 0}; // silence start

  SDL_AudioDeviceID deviceID = start_audio(&audioState);
  if (deviceID == 0) {
      printf("Erro: Falha ao abrir o dispositivo de áudio!\n");
  }

  char *programPath = (argc >= 2) ? argv[1] : (char *)"src/assembler/prog1.bin";
  
  VM vm;
  vm.load(programPath);
  vm.attachAudio(&audioState);
  while (vm.isRunning()) {
    vm.run();
  }
  finish_audio(deviceID);
  SDL_Quit();

  return 0;
}
