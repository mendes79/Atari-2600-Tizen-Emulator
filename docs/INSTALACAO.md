# Guia de instalação do Atari 2600 Tizen Emulator

Este guia mostra, passo a passo, como instalar o Atari 2600 Tizen Emulator na sua
própria Smart TV Samsung (Tizen). O processo é o mesmo que desenvolvedores usam
para testar aplicativos na TV (sideload com o Modo Desenvolvedor ligado).

Versão em inglês: veja [INSTALL.md](INSTALL.md).

Leia primeiro a seção do certificado. Ela explica por que não há um instalador de
um clique e por que cada pessoa precisa fazer alguns passos na primeira vez.

## Antes de começar: a restrição do certificado

A Samsung exige que todo aplicativo instalado na TV seja assinado com um
certificado válido. O certificado de distribuidor é amarrado ao DUID
(identificador único) da TV alvo. Na prática isso significa:

- Não existe um `.wgt` pronto que instale em qualquer TV. Um pacote assinado com o
  DUID de uma TV não instala em outra.
- Cada pessoa precisa gerar o próprio certificado, com a própria conta Samsung e o
  DUID da própria TV, e assinar o pacote.
- O passo de conta Samsung mais certificado por dispositivo não pode ser
  automatizado. Por isso a instalação é feita por este guia passo a passo e não
  por um instalador automático.

Fonte: Samsung Developers, "Creating Certificates".

## Pré-requisitos

- Uma Smart TV Samsung com Tizen (o projeto foi validado numa Samsung 65BU8000,
  Tizen 6.5).
- Um PC Windows na mesma rede da TV (cabo ou Wi-Fi).
- Uma conta gratuita no Portal Samsung Developers (https://developer.samsung.com).
- Tizen Studio instalado, com o pacote "Samsung Certificate Extension".
- Os arquivos deste repositório baixados no PC.

Tempo estimado na primeira vez: 30 a 60 minutos. A maior parte (instalar o Tizen
Studio e criar o certificado) é feita só uma vez. As instalações seguintes são
rápidas.

## Passo 1: Instalar o Tizen Studio e a extensão de certificado

1. Baixe e instale o Tizen Studio (a versão com a IDE) do site da Samsung.
2. Abra o Tizen Studio Package Manager.
3. Na aba "Extension SDK", instale a "Samsung Certificate Extension".

> Imagem 01: Package Manager com a Samsung Certificate Extension instalada.

## Passo 2: Ativar o Modo Desenvolvedor na TV

1. Na TV, abra o Smart Hub e vá ao painel Apps.
2. Abra "Configurações de Apps" (App Settings).
3. Digite 12345 no controle ou no teclado da tela. Aparece o popup de Modo
   Desenvolvedor.
4. Ligue o "Modo Desenvolvedor" (Developer mode).
5. Informe o endereço IP do PC que vai se conectar à TV e confirme em "OK".
6. Reinicie a TV. Depois de reiniciar, aparece "Develop Mode" no topo do painel
   Apps.

Para achar o IP do PC no Windows: abra o Prompt de Comando, rode `ipconfig` e use
o "Endereço IPv4" da sua rede.

> Imagem 02: popup do Modo Desenvolvedor na TV com o IP do PC preenchido.

## Passo 3: Descobrir o IP da TV e conectar

1. Na TV: Configurações > Geral (ou Conexão) > Rede > Status da Rede >
   Configurações de IP. Anote o IP da TV.
2. No PC, abra o Tizen Studio e vá em "Tools > Device Manager".
3. Clique em "Remote Device Manager" e no botão "+".
4. Em "Add Device", informe um nome, o IP da TV e a porta 26101, e clique em "Add".
5. Selecione a TV na lista e mude "Connection" para "On". A TV deve aparecer como
   conectada.

> Imagem 03: Device Manager com a TV conectada.

## Passo 4: Obter o DUID da TV

O DUID é o identificador único da TV, necessário para criar o certificado. Há duas
formas de obtê-lo:

- Na TV: Menu > Suporte > Fale com a Samsung > "ID Único do Dispositivo".
- No Tizen Studio: com a TV conectada (Passo 3), o DUID também pode ser puxado
  direto do dispositivo conectado ao criar o certificado (Passo 5).

> Imagem 04: DUID exibido (na TV ou no assistente do Tizen Studio).

## Passo 5: Criar o certificado Samsung

1. No Tizen Studio, abra "Tools > Certificate Manager".
2. Se aparecer o diálogo "Migration for Certificate Profile", clique em "Cancel".
3. Clique em "+" para abrir o assistente de criação de perfil.
4. Clique em "Samsung".
5. Selecione "TV" e clique em "Next".
6. Dê um nome ao perfil e clique em "Next". Guarde esse nome: ele é usado para
   assinar o pacote.
7. Certificado de autor:
   - Escolha "Create a new author certificate" e clique em "Next".
   - Preencha os dados e clique em "Next".
   - Faça login com sua conta Samsung Developer.
   - Defina um caminho de backup para o arquivo do certificado e clique em "Next".
8. Certificado de distribuidor:
   - Escolha "Create a new distributor certificate" e clique em "Next".
   - Defina o nível de privilégio necessário.
   - Informe o DUID da TV manualmente, ou clique no "+" ao lado do dispositivo
     conectado na lista.
9. Clique em "Finish".

Importante: guarde o certificado de autor em lugar seguro. Atualizações do app
precisam ser assinadas com o mesmo certificado de autor, senão a TV pode tratar a
nova versão como um aplicativo diferente.

> Imagem 05: assistente do Certificate Manager no passo do DUID.

## Passo 6: Importar o projeto no Tizen Studio

1. No Tizen Studio, use "File > Import > Tizen > Tizen Project".
2. Aponte para a pasta deste repositório (a raiz, onde estão o `config.xml` e o
   `index.html`).
3. Confirme que o perfil de certificado ativo é o que você criou. No Certificate
   Manager, o perfil ativo fica marcado.

> Imagem 06: projeto importado com o perfil de certificado ativo.

## Passo 7: Empacotar, assinar, instalar e abrir

Com a TV conectada (Passo 3) e o perfil de certificado ativo (Passo 5):

1. Clique com o botão direito no projeto importado.
2. Escolha "Run As > Tizen Web Application".
3. O Tizen Studio empacota, assina, instala e abre o app na TV numa única ação.

Pronto. O ícone do Atari 2600 Tizen Emulator aparece na TV, e o app pode ser
aberto pelo lilauncher.

> Imagem 07: Atari 2600 Tizen Emulator rodando na TV.

## Passo 8: Adicionar suas ROMs para aparecerem na tela de seleção

O app monta a tela de seleção a partir de dois arquivos de catálogo que lê ao
iniciar: `roms_pub.json` (a ROM livre incluída, já pronta) e `roms.json` (suas
ROMs, mantidas privadas e ignoradas pelo git). Uma cópia nova traz só a ROM livre,
então, para ver seus jogos, adicione-os assim:

1. Crie uma pasta `roms/` na raiz do projeto (ao lado do `index.html`), se não
   existir.
2. Copie seus arquivos `.a26` ou `.bin` legais para dentro de `roms/`.
3. Crie ou edite o `roms.json` na raiz do projeto. É um array JSON com uma entrada
   por ROM, cada uma com `file`, `name` e `slug`:

   ```json
   [
     { "file": "demon_attack.a26", "name": "Demon Attack", "slug": "demon_attack" },
     { "file": "river_raid.a26",   "name": "River Raid",   "slug": "river_raid" }
   ]
   ```

   - `file` precisa ser igual ao nome do arquivo dentro de `roms/` (inclusive
     maiúsculas e minúsculas).
   - `name` é o rótulo que aparece na tela.
   - `slug` é um identificador em minúsculas, um por jogo (letras, números,
     underscore).
4. Reinstale o app (repita o Passo 7). As ROMs são empacotadas dentro do `.wgt`,
   então é preciso uma nova instalação para a TV enxergar ROMs novas. Os jogos
   passam a aparecer na tela de seleção, mesclados e ordenados junto com a ROM
   livre.

Se um jogo não aparecer, confira que o `file` no `roms.json` é igual ao arquivo em
`roms/`, e que o `roms.json` é um JSON válido (sem vírgula sobrando).

## Alternativa por linha de comando

Se você se sente à vontade no terminal, dá para fazer os mesmos passos pelo Tizen
CLI em vez da interface. O fluxo é: conectar com `sdb`, montar o pacote com `tizen
build-web`, assinar com `tizen package -s <seu-perfil>` e instalar com `tizen
install`. Veja a referência do Tizen Studio CLI para a sintaxe exata. A assinatura
usa o mesmo perfil de certificado criado no Passo 5.

## Solução de problemas

- A TV não conecta no Device Manager: confirme que PC e TV estão na mesma rede,
  que o Modo Desenvolvedor está ligado com o IP do PC correto, e que a TV foi
  reiniciada. A porta é 26101.
- Erro de assinatura ao empacotar: confirme que o perfil de certificado está ativo
  no Certificate Manager e que o DUID informado é o da TV alvo.
- Instala numa TV mas não em outra: comportamento esperado. O certificado é
  amarrado ao DUID. Crie um novo certificado com o DUID da outra TV.
- Uma ROM não aparece: confira o `roms.json` (JSON válido, `file` igual ao arquivo
  em `roms/`) e reinstale o app.

## Resumo

- O certificado de distribuidor é amarrado ao DUID da TV, então cada TV precisa do
  próprio certificado.
- Não é possível distribuir um `.wgt` pronto que instale em qualquer TV por este
  caminho (sideload).
- Suas ROMs são adicionadas em `roms/` e listadas no `roms.json`; só a ROM livre é
  publicada no repositório.

## Referências

- Samsung Developers, Creating Certificates:
  https://developer.samsung.com/smarttv/develop/getting-started/setting-up-sdk/creating-certificates.html
- Samsung Developers, TV device (Developer Mode):
  https://developer.samsung.com/tv/develop/getting-started/using-sdk/tv-device
