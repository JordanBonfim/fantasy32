#pragma once
#include <atomic>
#include <SDL2/SDL.h>

struct AudioState {
    std::atomic<float> frequency;     //  Equivalente ao ra (Hz)
    std::atomic<int> duration;       //   Equivalente ao rb traduzido para frames
    std::atomic<int> waveForm;      //    Equivalente ao rc (0=SINE, 1=SQUARE, 2=NOISE)
    std::atomic<double> phase;
};

SDL_AudioDeviceID start_audio(AudioState *state);

void finish_audio(SDL_AudioDeviceID deviceID);