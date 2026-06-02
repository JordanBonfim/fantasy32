#pragma once
#include <SDL2/SDL.h>
#include <map>
// typedef enum {
//   ARROW_LEFT = 0x00,
//   ARROW_RIGHT = 0x01,
//   ARROW_UP = 0x02,
//   ARROW_DOWN = 0x03,
//   SPACE = 0x04,
//   ENTER = 0x05,
//   KEY_N = 0x06,
//   KEY_M = 0x07,
//   KEY_A = 0x08,
//   KEY_S = 0x09,
//   KEY_D = 0x0A,
//   KEY_W = 0x0B,
//   KEY_Q = 0x0C,
//   KEY_E = 0x0D,
//   KEY_C = 0x0E,
//   KEY_V = 0x0F,

// } KeyCode;

class Keyboard {
private:
  // Estado das 16 teclas (0-15): true = pressionada, false = solta [1]
  bool keyStates[2];

  // Mapeamento de SDL_Keycode para os IDs da Fantasys32 [1]
  std::map<SDL_Keycode, int> keyMap;

public:
  Keyboard();

  // Processa um evento SDL e atualiza o estado interno
  void handleEvent(const SDL_Event &event);

  // Retorna o estado de uma tecla específica para a instrução GKEY [1, 3]
  bool isKeyPressed(int keyID) const;
};