#define MINIAUDIO_IMPLEMENTATION
#include <audio.h>
#include <miniaudio.h>

#include <atomic>
#include <cmath>
#include <cstdlib>
#include <cstring>

void data_callback(ma_device *pDevice, void *pOutput, const void *pInput,
                   ma_uint32 frameCount) {
  AudioState *state = (AudioState *)pDevice->pUserData;

  float current_freq = state->frequency.load();
  int current_time = state->duration.load();
  int current_wave = state->waveForm.load();
  double current_phase = state->phase.load();

  if (current_time <= 0) {
    memset(pOutput, 0, frameCount * sizeof(float));
    return;
  }

  float *saida = (float *)pOutput;

  for (ma_uint32 i = 0; i < frameCount; i++) {
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
      saida[i] = sampleValue;
    }else{
      saida[i] = 0.0f;
    }

  }
  state->phase.store(current_phase);
}

bool start_miniaudio(ma_device *device, AudioState *state) {
  ma_device_config config = ma_device_config_init(ma_device_type_playback);
  config.playback.format = ma_format_f32;
  config.playback.channels = 1;  // 0 to use the device's native channel count.
  config.sampleRate = 48000;     // 0 to use the device's native sample rate.
  config.dataCallback = data_callback;  // This function will be called when
                                        // miniaudio needs more data.
  config.pUserData =
      state;  // Can be accessed from the device object (device.pUserData).

  if (ma_device_init(NULL, &config, device) != MA_SUCCESS) {
    return 0;  // Failed to initialize the device.
  }

  ma_device_start(device);
  return 1;
}

void finish_miniaudio(ma_device *device) { ma_device_uninit(device); }