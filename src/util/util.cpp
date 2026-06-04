#include <font.h>
#include <cstdint>

bool isInsideMem(int value) {
  return value >= 0x00000000 && value < 0x00ffffff;
}

void drawText(int x, int y, const char *text, uint32_t color, uint32_t width, uint32_t *base) {
  while (*text != '\0') {
    uint8_t character = (uint8_t)*text;
    uint64_t characterBitmap = font[character - ' '];
    for (int row = 0; row < 8; row++) {
      uint8_t line = (characterBitmap >> ((7 - row) * 8)) & 0xFF;
      for (int col = 0; col < 8; col++) {
        if (line & (1 << (7 - col))) {
          base[(y + row) * width + (x + col)] = color;
        }
      }
    }
    x += 8;
    text++;
  }
}