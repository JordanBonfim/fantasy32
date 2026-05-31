CXX      := g++
CXXFLAGS := -std=c++17 -Wall -O0 -g -MMD -MP
INCLUDES := -Isrc/vm -Isrc/game -Isrc/utils
SRC_DIRS := src/vm src/game src/utils
BUILD_DIR := build
TARGET    := $(BUILD_DIR)/app
BIN ?= src/assembler/prog1.bin

SRCS := src/main.cpp $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.cpp))
OBJS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

.PHONY: all clean run

all: $(TARGET)

run: $(TARGET)
	$(TARGET) $(BIN)

$(TARGET): $(OBJS)
	$(CXX) $^ -o $@

$(BUILD_DIR)/%.o: %.cpp
	mkdir -p $(dir $@)        
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

-include $(DEPS)

clean:
	rm -rf $(BUILD_DIR)