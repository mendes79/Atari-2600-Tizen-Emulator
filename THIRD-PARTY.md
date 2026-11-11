# Third-party components and their licenses

The original application code of this project is under the MIT License (see LICENSE).
The components below are third-party and keep their own licenses. This project is
free and non-commercial.

## Stella 2014 (emulation core)

- Files: `js/stella.wasm`, `js/stella.js` (compiled with Emscripten).
- Origin: stella2014-libretro (https://github.com/libretro/stella2014-libretro),
  derived from the Stella Atari 2600 emulator (https://github.com/stella-emu/stella).
- License: GNU GPL v2 (Stella and stella2014-libretro are GPL-2.0). The core is
  redistributed under that license; the corresponding source is available at the
  links above.
- This project does not sell the core nor the application. The core is bundled
  only to run the emulator on the target TV.
- Build reproducibility: see `core/` (build.sh, build.ps1 and VERSION.md),
  Emscripten emcc 3.1.56, single-thread scalar, `-mno-simd128`.

## Firefly (bundled free ROM)

- Files: `roms_pub/firefly.a26`, with its assembly source `roms_pub/firefly.asm`.
- Author: retroromrunner.
- Origin: https://github.com/retroromrunner/firefly-atari-2600
- License: public domain. The project README states: "Public domain. Do whatever
  you want with it."
- The binary is redistributed unmodified; the source is included for transparency.
  See `roms_pub/CREDITS.md`.

## Artwork

- Selection wallpaper (`img/tv_atari.jpg`), app icon (`icon.png`,
  `img/atari_tz_icon.png`) and the highlight overlays (`img/overlays/`) are
  authored for this project. The overlays are original green highlight graphics
  rendered to line up with the controller photo.
- Controller photo and console panel (`img/joy_atari_real.jpg`), plus the CX40
  reference drawings (`img/joy_atari.jpg`, `img/joy_atari_base.jpg`,
  `img/CX40-joystick-dimensions.svg`): used as the base of the joystick
  configuration diagram. NOTE FOR THE MAINTAINER: confirm the exact source and
  license of these controller images and record it here before publishing. If the
  source does not permit redistribution, replace them with an image that does or
  with an original drawing.

## Commercial ROMs

- Commercial game ROMs are NOT included in this repository. The private `roms/`
  folder and `roms.json` are git-ignored. Only freely distributable ROMs ship in
  `roms_pub/`.
