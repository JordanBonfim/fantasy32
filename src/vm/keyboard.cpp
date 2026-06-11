#include "keyboard.h"

Keyboard::Keyboard() {
  for (int i = 0; i < 16; ++i)
    keyStates[i] = false;

  keyMap[SDLK_LEFT] = 0;
  keyMap[SDLK_RIGHT] = 1;
  keyMap[SDLK_UP] = 2;
  keyMap[SDLK_DOWN] = 3;
  keyMap[SDLK_SPACE] = 4;
  keyMap[SDLK_RETURN] = 5; // ENTER
  keyMap[SDLK_n] = 6;
  keyMap[SDLK_m] = 7;
  keyMap[SDLK_a] = 8;
  keyMap[SDLK_s] = 9;
  keyMap[SDLK_d] = 10;
  keyMap[SDLK_w] = 11;
  keyMap[SDLK_q] = 12;
  keyMap[SDLK_e] = 13;
  keyMap[SDLK_c] = 14;
  keyMap[SDLK_v] = 15;
}

void Keyboard::handleEvent(const SDL_Event &event) {
  if (event.type == SDL_KEYDOWN || event.type == SDL_KEYUP) {
    auto it = keyMap.find(event.key.keysym.sym);
    if (it != keyMap.end()) {
      keyStates[it->second] = (event.type == SDL_KEYDOWN);
    }
  }
}

bool Keyboard::isKeyPressed(int keyID) const {
  if (keyID >= 0 && keyID < 16) {
    return keyStates[keyID];
  }
  return false;
}
