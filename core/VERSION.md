# Build Reproduzível — Stella 2014 Libretro WASM (`stella.wasm`)

- **Repositório Fonte:** `https://github.com/EmulatorJS/stella2014-libretro.git`
- **Commit Fixo (Pinado):** `1f578c36382bb5a86a0fe245973fa557f369738b`
- **Toolchain Emscripten:** `emcc 3.1.56 (cf90417346b78455089e64eb909d71d091ecc055)`
- **Target:** Chromium M85 (Tizen 6.5) — single-thread escalar (`-O3 -flto -fno-exceptions -fno-rtti -mno-simd128`, sem `-pthread`).
- **Tamanho resultante:**
  - `stella.wasm`: **1.053.144 bytes (1,00 MB)** (redução de **77,6%** em relação aos 4,59 MB do `stella2014_libretro.wasm` do EmulatorJS)
  - `stella.js`: **27.209 bytes (26,5 KB)** (`-sMODULARIZE=1 -sEXPORT_NAME=StellaCore -sFILESYSTEM=0`)
- **Símbolos Exportados (`EXPORTED_FUNCTIONS`):**
  - `_retro_init`, `_retro_deinit`, `_retro_api_version`, `_retro_get_system_info`, `_retro_get_system_av_info`, `_retro_set_environment`, `_retro_set_video_refresh`, `_retro_set_audio_sample`, `_retro_set_audio_sample_batch`, `_retro_set_input_poll`, `_retro_set_input_state`, `_retro_set_controller_port_device`, `_retro_reset`, `_retro_run`, `_retro_load_game`, `_retro_unload_game`, `_retro_get_region`, `_retro_serialize_size`, `_retro_serialize`, `_retro_unserialize`, `_malloc`, `_free`

## Como reproduzir o artefato

No Linux/WSL:
```bash
cd cores/stella
./build.sh
```

No Windows PowerShell:
```powershell
cd C:\Users\mende\Projetos\tv
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\cores\stella\build.ps1
```

