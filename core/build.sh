#!/usr/bin/env bash
# build.sh — Build reproduzível do núcleo Stella 2014 (libretro) para WebAssembly (Etapa 1 de PLANO-ATARI-WASM.md)
# Disciplinas obrigatórias (Seção 3):
#   - Fonte pinado: https://github.com/EmulatorJS/stella2014-libretro @ commit 1f578c36382bb5a86a0fe245973fa557f369738b
#   - Compilador pinado: Emscripten emcc 3.1.56 (cf90417346b78455089e64eb909d71d091ecc055)
#   - WASM single-thread escalar (-O3 -flto, SEM -pthread, SEM -msimd128) para Chromium M85 (Tizen 6.5)
#   - MODULARIZE=1, EXPORT_NAME=StellaCore, ABI libretro retro_* exposta

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="${SCRIPT_DIR}/stella2014-libretro"
BUILD_DIR="${SCRIPT_DIR}/build"
REPO_URL="https://github.com/EmulatorJS/stella2014-libretro.git"
PINNED_COMMIT="1f578c36382bb5a86a0fe245973fa557f369738b"

if [ ! -d "${SRC_DIR}" ]; then
  git clone "${REPO_URL}" "${SRC_DIR}"
fi

git -C "${SRC_DIR}" checkout "${PINNED_COMMIT}"

EMCC="${EMCC:-emcc}"
EMXX="${EMXX:-em++}"

echo "=== Toolchain Version ==="
"${EMCC}" --version

mkdir -p "${BUILD_DIR}"

INC_FLAGS=(
  -I"${SRC_DIR}"
  -I"${SRC_DIR}/stella"
  -I"${SRC_DIR}/stella/src"
  -I"${SRC_DIR}/stella/stubs"
  -I"${SRC_DIR}/stella/src/emucore"
  -I"${SRC_DIR}/stella/src/common"
  -I"${SRC_DIR}/stella/src/gui"
  -I"${SRC_DIR}/libretro-common/include"
)

COMMON_FLAGS=(
  -O3
  -flto
  -DNDEBUG
  -ffast-math
  -fno-strict-overflow
  -D__LIBRETRO__
  -DTHUMB_SUPPORT
  -fno-exceptions
  -fno-rtti
  -mno-simd128
)

CXX_SOURCES=(
  stella/src/common/Base.cxx
  stella/src/common/Sound.cxx
  stella/src/emucore/AtariVox.cxx
  stella/src/emucore/Booster.cxx
  stella/src/emucore/Cart.cxx
  stella/src/emucore/Cart0840.cxx
  stella/src/emucore/Cart2K.cxx
  stella/src/emucore/Cart3E.cxx
  stella/src/emucore/Cart3F.cxx
  stella/src/emucore/Cart4A50.cxx
  stella/src/emucore/Cart4K.cxx
  stella/src/emucore/Cart4KSC.cxx
  stella/src/emucore/CartAR.cxx
  stella/src/emucore/CartBF.cxx
  stella/src/emucore/CartBFSC.cxx
  stella/src/emucore/CartCM.cxx
  stella/src/emucore/CartCTY.cxx
  stella/src/emucore/CartCV.cxx
  stella/src/emucore/CartDF.cxx
  stella/src/emucore/CartDFSC.cxx
  stella/src/emucore/CartDPC.cxx
  stella/src/emucore/CartDPCPlus.cxx
  stella/src/emucore/CartE0.cxx
  stella/src/emucore/CartE7.cxx
  stella/src/emucore/CartEF.cxx
  stella/src/emucore/CartEFSC.cxx
  stella/src/emucore/CartF0.cxx
  stella/src/emucore/CartF4.cxx
  stella/src/emucore/CartF4SC.cxx
  stella/src/emucore/CartF6.cxx
  stella/src/emucore/CartF6SC.cxx
  stella/src/emucore/CartF8.cxx
  stella/src/emucore/CartF8SC.cxx
  stella/src/emucore/CartFA.cxx
  stella/src/emucore/CartFA2.cxx
  stella/src/emucore/CartFE.cxx
  stella/src/emucore/CartMC.cxx
  stella/src/emucore/CartSB.cxx
  stella/src/emucore/CartUA.cxx
  stella/src/emucore/CartX07.cxx
  stella/src/emucore/CompuMate.cxx
  stella/src/emucore/Console.cxx
  stella/src/emucore/Control.cxx
  stella/src/emucore/Driving.cxx
  stella/src/emucore/Genesis.cxx
  stella/src/emucore/Joystick.cxx
  stella/src/emucore/Keyboard.cxx
  stella/src/emucore/KidVid.cxx
  stella/src/emucore/M6502.cxx
  stella/src/emucore/M6532.cxx
  stella/src/emucore/MD5.cxx
  stella/src/emucore/MindLink.cxx
  stella/src/emucore/MT24LC256.cxx
  stella/src/emucore/NullDev.cxx
  stella/src/emucore/Paddles.cxx
  stella/src/emucore/Props.cxx
  stella/src/emucore/PropsSet.cxx
  stella/src/emucore/Random.cxx
  stella/src/emucore/SaveKey.cxx
  stella/src/emucore/Serializer.cxx
  stella/src/emucore/Settings.cxx
  stella/src/emucore/StateManager.cxx
  stella/src/emucore/Switches.cxx
  stella/src/emucore/System.cxx
  stella/src/emucore/Thumbulator.cxx
  stella/src/emucore/TIA.cxx
  stella/src/emucore/TIASnd.cxx
  stella/src/emucore/TIATables.cxx
  stella/src/emucore/TrackBall.cxx
  libretro.cxx
)

C_SOURCES=(
  libretro-common/compat/compat_posix_string.c
  libretro-common/compat/compat_strcasestr.c
  libretro-common/compat/compat_snprintf.c
  libretro-common/compat/compat_strl.c
  libretro-common/compat/fopen_utf8.c
  libretro-common/encodings/encoding_utf.c
  libretro-common/file/file_path.c
  libretro-common/file/file_path_io.c
  libretro-common/time/rtime.c
  libretro-common/streams/file_stream.c
  libretro-common/streams/file_stream_transforms.c
  libretro-common/string/stdstring.c
  libretro-common/vfs/vfs_implementation.c
)

OBJECTS=()
for src in "${CXX_SOURCES[@]}"; do
  obj="${BUILD_DIR}/$(basename "${src}" .cxx).o"
  "${EMXX}" -c "${SRC_DIR}/${src}" -o "${obj}" "${COMMON_FLAGS[@]}" "${INC_FLAGS[@]}"
  OBJECTS+=("${obj}")
done

for src in "${C_SOURCES[@]}"; do
  obj="${BUILD_DIR}/$(basename "${src}" .c).o"
  "${EMCC}" -c "${SRC_DIR}/${src}" -o "${obj}" "${COMMON_FLAGS[@]}" "${INC_FLAGS[@]}"
  OBJECTS+=("${obj}")
done

EXPORTED_FUNCTIONS='["_retro_init","_retro_deinit","_retro_api_version","_retro_get_system_info","_retro_get_system_av_info","_retro_set_environment","_retro_set_video_refresh","_retro_set_audio_sample","_retro_set_audio_sample_batch","_retro_set_input_poll","_retro_set_input_state","_retro_set_controller_port_device","_retro_reset","_retro_run","_retro_load_game","_retro_unload_game","_retro_get_region","_retro_serialize_size","_retro_serialize","_retro_unserialize","_malloc","_free"]'
EXPORTED_RUNTIME_METHODS='["cwrap","ccall","addFunction","removeFunction","UTF8ToString","stringToUTF8","HEAPU8","HEAP8","HEAPU16","HEAP16","HEAPU32","HEAP32","HEAPF32"]'

"${EMXX}" "${OBJECTS[@]}" -o "${SCRIPT_DIR}/stella.js" \
  -O3 -flto -fno-exceptions -fno-rtti -mno-simd128 \
  -sWASM=1 \
  -sMODULARIZE=1 \
  -sEXPORT_NAME="StellaCore" \
  -sALLOW_TABLE_GROWTH=1 \
  -sALLOW_MEMORY_GROWTH=1 \
  -sINITIAL_MEMORY=16777216 \
  -sFILESYSTEM=0 \
  -sENVIRONMENT='web,node' \
  -sEXPORTED_FUNCTIONS="${EXPORTED_FUNCTIONS}" \
  -sEXPORTED_RUNTIME_METHODS="${EXPORTED_RUNTIME_METHODS}"

ls -lh "${SCRIPT_DIR}/stella.wasm" "${SCRIPT_DIR}/stella.js"
