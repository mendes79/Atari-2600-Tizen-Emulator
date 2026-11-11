# Inventario de unificacao - atari_tz

Data: 2026-11-11. Fase 0 do plano de padronizacao (ver projeto, doc 11).
Objetivo: consolidar as varias pastas de Atari espalhadas na raiz do repo `tv` em uma
pasta unica `atari_tz/`, no padrao do SNES Tizen Emulator.

## Origem de cada parte de atari_tz/

- `index.html`, `config.xml`, `icon.png`, `js/`, `roms/`, `roms.json`
  Origem: `atari2600-core/` (engine vencedora: nucleo Stella 2014 em WASM com ABI retro_*).
  `config.xml`: package id canonico `lilatari01` (10 chars), v2.0.0.
- `img/tv_atari.jpg` (wallpaper com a TV desenhada) e `img/atari_tz_icon.png`.
  Origem: `atari/img/`.
  Nota: a foto do controle usada na config e `img/joy_atari_real.jpg` (montada de
  imagens livres do Unsplash, licenca Unsplash). As imagens de controle nao usadas e
  sem licenca clara (`joy_atari.jpg`, `joy_atari_base.jpg`, `CX40-joystick-dimensions.svg`)
  ficam fora do repositorio publico (gitignored) e nao vao ao GitHub.
- `img/shots/` Origem: `atari2600-core/img/shots`.
- `roms_pub/` criada vazia (.gitkeep); sera povoada na Fase 3 com ROM livre.

## Nucleo (nao recompilar)

- `js/stella.wasm` (1,05 MB) + `js/stella.js` (27 KB): Stella 2014 recompilado com
  Emscripten 3.1.56, single-thread escalar (-mno-simd128). Validado na TV (ver
  docs/ESTUDO-CASO-ATARI-WASM-TIZEN.md na raiz).
- `js/adapter-stella.js`: fronteira do adapter (init/runFrame/pushInput/getAudio/reset/
  setSpeedScale), frontend libretro minimo.
- `js/hud.js`: HUD de medicao honesta (EMU% real).
- Build reproduzivel do nucleo fica fora deste repo, em `tv/cores/stella/`.

## Pendente de poda na Fase 1

- `js/adapter-javatari.js` e `js/javatari-core.js` (668 KB): caminho Javatari (perdedor,
  ~45-77% de velocidade real). Vieram junto para o app seguir funcionando na Fase 0; serao
  removidos quando o `index.html` for substituido pela home padrao (Fase 1), que usara so o
  adapter Stella.
- `roms/` hoje tem o acervo comercial (61 .a26) com nomes nao normalizados; a curadoria e o
  split definitivo (roms/ privada + roms_pub/ livre) sao da Fase 3.

## Backup / rollback

- `../rollback/atari-pre-unificacao.tar.gz` (39 MB): snapshot completo pre-unificacao das 5
  pastas (atari, atari-app, atari2600-app, atari2600-core, atari2600-lean) + 3 zips
  (atari-app.zip, atari-app-safe.zip, atari-deploy.zip). Restauravel com `tar -xzf`.

## Descartado (perdedor)

Removido da raiz apos o backup (engines abandonadas por desempenho):
- `atari/` (EmulatorJS), `atari-app/` (EmulatorJS, deploy antigo),
  `atari2600-app/` (Javatari + testes), `atari2600-lean/` (Javatari lean),
  e os zips `atari-app.zip`, `atari-app-safe.zip`, `atari-deploy.zip`.
- `atari2600-core/` mantido temporariamente como rede de seguranca viva; sera removido
  depois que `atari_tz` for validado na TV na Fase 1.
