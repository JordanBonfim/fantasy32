#include "audio.h"
#include "vm/vm.h"
#include <SDL2/SDL.h>
#include <cstring>
#include <stdio.h>
#include <stdlib.h>

static void print_help(const char *progName) {
  printf("Uso: %s [opcoes] caminho/para/o/arquivo.bin\n", progName);
  printf("\n");
  printf("Opcoes:\n");
  printf("  --scale <fator>   Define o fator de escala da janela. "
         "Padrao: 1.\n");
  printf("  --no-syscall      Desativa a execucao da instrucao SYSCALL.\n");
  printf("  --help, -h        Exibe esta mensagem de ajuda.\n");
  printf("\n");
  printf("Exemplo: %s --scale 2 --no-syscall jogo.bin\n", progName);
}

int main(int argc, char **argv) {
  int scale = 1;
  bool no_syscall = false;
  const char *programPath = nullptr;

  for (int i = 1; i < argc; i++) {
    if (strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
      print_help(argv[0]);
      return 0;
    } else if (strcmp(argv[i], "--scale") == 0) {
      if (i + 1 >= argc) {
        printf("Erro: --scale requer um valor (ex: --scale 2)\n");
        return -1;
      }
      scale = atoi(argv[++i]);
      if (scale <= 0) {
        printf("Erro: o fator de escala deve ser um inteiro positivo.\n");
        return -1;
      }
    } else if (strcmp(argv[i], "--no-syscall") == 0) {
      no_syscall = true;
    } else if (argv[i][0] == '-') {
      printf("Erro: opcao desconhecida '%s'\n\n", argv[i]);
      print_help(argv[0]);
      return -1;
    } else {
      // primeiro argumento posicional = caminho do binario
      programPath = argv[i];
    }
  }

  if (programPath == nullptr) {
    programPath = "src/assembler/prog1.bin";
  }

  if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO) < 0) {
    printf("Erro: Falha ao iniciar SDL2: %s\n", SDL_GetError());
    return -1;
  }

  AudioState audioState = {0.0f, 0, 0, 0}; // silence start
  SDL_AudioDeviceID deviceID = start_audio(&audioState);
  if (deviceID == 0) {
    printf("Erro: Falha ao abrir o dispositivo de audio!\n");
  }

  VM vm = VM(scale, no_syscall);
  vm.load(programPath);
  vm.attachAudio(&audioState);
  vm.run();

  finish_audio(deviceID);
  SDL_Quit();
  return 0;
}