#pragma once
#include <atomic>

struct ma_device;
struct AudioState {
    std::atomic<float> frequency;     //  Equivalente ao ra (Hz)
    std::atomic<int> duration;       //   Equivalente ao rb traduzido para frames
    std::atomic<int> waveForm;      //    Equivalente ao rc (0=SINE, 1=SQUARE, 2=NOISE)
    std::atomic<double> phase;
};

bool start_miniaudio(ma_device* device, AudioState* state);

void finish_miniaudio(ma_device* device);