# Atari 2600 Tizen Emulator

Um emulador de Atari 2600 para Smart TVs Samsung com Tizen, empacotado como app web
(`.wgt`) e aberto pela tela inicial do lilauncher. Roda o núcleo Stella 2014
recompilado para WebAssembly e joga em velocidade cheia num SoC de TV modesto.

Versão em inglês: veja [README.md](README.md).

## O que é

- Aparelho alvo: Samsung 65BU8000 (2022, Crystal UHD), Tizen 6.5, motor web
  Chromium M85.
- Núcleo: Stella 2014 recompilado para um módulo WebAssembly enxuto, single-thread
  escalar (sem SIMD, sem threads), para validar e rodar no Chromium M85 antigo.
- Entregue como pacote Tizen `.wgt`. É a mesma WebView do navegador da TV, então
  não há binário nativo do lado do app.

## Recursos

- Emulação em velocidade cheia na TV alvo, validada com um medidor honesto de
  velocidade (quadros emulados por segundo real, não FPS nominal).
- Tela de seleção de jogos sobre um wallpaper temático, com navegação vertical e
  um painel de configurações.
- Configurações: som ligado/desligado e presets de redução de velocidade (100%,
  -6%, -8%, -10%), salvos localmente. Vários jogos do Atari ficam um pouco rápidos
  demais a 100%, por isso o padrão é -6%.
- Configuração de joystick interativa: um assistente mapeia cada comando, com a
  foto real do controle que acende o comando pressionado. Como o Atari usa as
  chaves do console para Game Select e Game Reset, o diagrama também acende essas
  chaves do painel.
- Comandos: direcional, Fire, Select e Reset. Funciona com um 8BitDo Ultimate
  2.4G (dongle USB HID) via Gamepad API, e o conjunto simples também cabe no
  controle remoto da TV. Select+Start volta à tela de seleção durante o jogo.
- Split do catálogo: ROMs comerciais privadas ficam locais e nunca são publicadas;
  ROMs de distribuição livre ficam em `roms_pub/`.

## ROM livre incluída

- Firefly, de retroromrunner, em domínio público. Um homebrew completo de Atari
  2600 (tela de título, um firefly que você move pelo joystick, um inimigo
  perseguidor, pontuação, salas e som) que também serve de teste de tela, controle
  e som. Veja `roms_pub/CREDITS.md`.

## Estrutura do repositório

- `index.html` e `js/` : a aplicação (UI, input, áudio, HUD, adapter frontend
  libretro).
- `js/stella.wasm` / `js/stella.js` : o núcleo compilado.
- `core/` : registro de build do núcleo (build reproduzível com Emscripten 3.1.56).
- `img/` : wallpaper, ícone do app, foto do controle e máscaras de destaque.
- `roms_pub/` : ROMs de distribuição livre (publicadas), com `roms_pub.json`.
- `roms/`, `roms.json` : ROMs comerciais privadas e catálogo (ignorados pelo git,
  não publicados).

## Instalação

### 1. Ativar o Modo Desenvolvedor na TV

1. Na TV, abra o painel Apps e abra Configurações de Apps.
2. Digite `12345` no controle. Aparece o popup de Modo Desenvolvedor.
3. Ligue o Modo Desenvolvedor e informe o IP do seu PC na rede.
4. Reinicie a TV.

### 2. Montar, assinar e instalar o app

A Samsung assina todo app da TV com um certificado amarrado ao DUID daquela TV
específica, então um `.wgt` pronto não pode ser compartilhado entre TVs. Pelo
Tizen Studio no Windows, crie um certificado Samsung com o DUID da sua TV, depois
monte, assine e instale o app pela rede e abra. É uma configuração única; as
instalações seguintes são rápidas.

### 3. Adicionar suas ROMs para aparecerem na tela de seleção

A tela de seleção é montada a partir de dois arquivos de catálogo que o app lê ao
iniciar. A ROM livre já vem listada em `roms_pub.json`. Para ver seus próprios
jogos, você precisa adicioná-los e listá-los no `roms.json` (mantido privado,
ignorado pelo git):

1. Coloque seus arquivos `.a26` ou `.bin` legais na pasta `roms/` (crie-a ao lado
   do `index.html` se ela não existir).
2. Crie ou edite o `roms.json` na raiz do projeto, um array JSON com uma entrada
   por ROM, cada uma com `file`, `name` e `slug`:

   ```json
   [
     { "file": "meu_jogo.a26", "name": "Meu Jogo", "slug": "meu_jogo" }
   ]
   ```

   - `file` precisa ser igual ao nome do arquivo dentro de `roms/`.
   - `name` é o que aparece na tela; `slug` é um identificador em minúsculas.
3. Reinstale o app (as ROMs são empacotadas no `.wgt`). Os jogos passam a aparecer
   na tela de seleção, mesclados e ordenados junto com a ROM livre.

Precisa de um passo a passo com telas? Veja o guia de instalação:
[docs/INSTALACAO.md](docs/INSTALACAO.md) (inglês: [docs/INSTALL.md](docs/INSTALL.md)).

## Licença

- Código original da aplicação: MIT (veja LICENSE).
- Componentes de terceiros mantêm suas licenças (veja THIRD-PARTY.md): o núcleo
  Stella 2014 sob GPL v2 e a ROM Firefly em domínio público. Este projeto é livre
  e não comercial.

## Aviso legal

Este projeto é um emulador independente e não oficial, desenvolvido apenas para
fins educacionais.

- Este repositório não inclui nenhuma ROM protegida por direitos autorais nem
  ativos proprietários. A única ROM incluída é a Firefly, em domínio público.
- O usuário deve fornecer suas próprias ROMs de Atari 2600 obtidas legalmente para
  jogar outros jogos. ROMs comerciais privadas ficam locais e nunca são publicadas.
- Este projeto não é afiliado, endossado nem associado à Atari nem ao Atari 2600
  (Video Computer System).
- Todas as marcas e marcas registradas pertencem aos seus respectivos donos.

## Créditos

- Núcleo Stella 2014: os autores do Stella e a equipe libretro.
- ROM Firefly: retroromrunner (domínio público).
- Foto do controle, wallpaper da seleção, ícone do app e máscaras de destaque:
  veja THIRD-PARTY.md.
- Harness de referência do GameBoy e o projeto lilauncher, no qual este emulador
  se encaixa.

## Relacionados

- lilauncher (tela inicial própria da TV): https://github.com/mendes79/lilauncher
