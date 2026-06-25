SDL_CFLAGS := $(shell sdl2-config --cflags)
SDL_LIBS   := $(shell sdl2-config --libs)
CXX      := g++
CXXFLAGS := -std=c++17 -Wall -O0 -g -MMD -MP $(SDL_CFLAGS)
INCLUDES := -Isrc/vm -Isrc/game -Isrc/utils
SRC_DIRS := src/vm src/game src/utils
BUILD_DIR := build
TARGET    := $(BUILD_DIR)/app
BIN ?= src/assembler/prog1.bin
ARGS ?=
ASSEMBLER := src/assembler/assembler
TETRIS_BIN := $(BUILD_DIR)/tetris
SPACE-SHOOTER_BIN := $(BUILD_DIR)/space-shooter
SRCS := src/main.cpp $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.cpp))
OBJS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

.PHONY: all clean run tetris space-shooter

all: $(TARGET)

run: $(TARGET)
	$(TARGET) $(ARGS) $(BIN)

compilar-tetris: $(TARGET)
	mkdir -p $(BUILD_DIR)
	$(ASSEMBLER) src/game/tetris/tetris.asm $(TETRIS_BIN)

tetris: $(TARGET)
	mkdir -p $(BUILD_DIR)
	$(ASSEMBLER) src/game/tetris/tetris.asm $(TETRIS_BIN)
	$(TARGET) $(ARGS) $(TETRIS_BIN)

compilar-space-shooter: $(TARGET)
	mkdir -p $(BUILD_DIR)
	$(ASSEMBLER) src/game/space-shooter/space_shooter.asm $(SPACE-SHOOTER_BIN)

space-shooter: $(TARGET)
	mkdir -p $(BUILD_DIR)
	$(ASSEMBLER) src/game/space-shooter/space_shooter.asm $(SPACE-SHOOTER_BIN)
	$(TARGET) $(ARGS) $(SPACE-SHOOTER_BIN)


$(TARGET): $(OBJS)
	$(CXX) $^ -o $@ $(SDL_LIBS)

$(BUILD_DIR)/%.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

-include $(DEPS)

clean:
	rm -rf $(BUILD_DIR)