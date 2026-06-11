#include "audio.h"
#include <atomic>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <SDL2/SDL.h>


void data_callback(void *userdata, Uint8 *stream, int len) {
  AudioState *state = (AudioState *)userdata;

  int frameCount = len / sizeof(float);

  float current_freq = state->frequency.load();
  int current_time = state->duration.load();
  int current_wave = state->waveForm.load();
  double current_phase = state->phase.load();

  float *output = (float *)stream; 

  for (int i = 0; i < frameCount; i++) {
    float sampleValue = 0.0f;

    if (state->duration > 0) {
      state->duration--;
      current_phase += current_freq / 48000.0;
      if (current_phase >= 1.0) current_phase -= 1.0; // Mantém entre 0.0 e 1.0
      switch (current_wave) {
        case 0:  // SINE
          sampleValue = sinf(2.0f * 3.14159265f * current_phase);
          break;
        case 1:  // SQUARE
          sampleValue = sinf(2.0f * 3.14159265f * current_phase);
          sampleValue = (sampleValue >= 0.0f) ? 1.0f : -1.0f;
          break;
        case 2: {  // TRIANGLE
          sampleValue = 4.0f * fabsf(current_phase - 0.5f) - 1.0f;
          break;
        }
        case 3: {
          float r = (float)rand() / (float)RAND_MAX;
          sampleValue = (r * 2.0f) - 1.0f;
          break;
        }
      }
      output[i] = sampleValue;
    }else{
      output[i] = 0.0f;
    }
  }
  state->phase.store(current_phase);
}

SDL_AudioDeviceID start_audio(AudioState *state) {
  SDL_AudioSpec desiredSpec, obtainedSpec;
  
  SDL_zero(desiredSpec); // zerar memoria
  
  desiredSpec.freq = 48000;
  desiredSpec.format = AUDIO_F32; 
  desiredSpec.channels = 1;
  desiredSpec.samples = 512;
  desiredSpec.callback = data_callback;
  desiredSpec.userdata = state; 


  SDL_AudioDeviceID deviceID = SDL_OpenAudioDevice(NULL, 0, &desiredSpec, &obtainedSpec, 0);
  
  if (deviceID == 0) {
    return 0; 
  }

  SDL_PauseAudioDevice(deviceID, 0); 
  
  return deviceID;
}

void finish_audio(SDL_AudioDeviceID deviceID) { 
    if (deviceID != 0) {
        SDL_CloseAudioDevice(deviceID); 
    }
}