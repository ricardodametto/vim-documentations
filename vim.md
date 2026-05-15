# Vim — Documentação do Ambiente

Configuração do Vim como IDE para C/C++ e uso geral no Arch Linux.

---

## Índice

1. [Compilação do Vim a partir do fonte](#1-compilação-do-vim-a-partir-do-fonte)
2. [Estrutura de arquivos](#2-estrutura-de-arquivos)
3. [Dependências do sistema](#3-dependências-do-sistema)
4. [Gerenciador de plugins: vim-plug](#4-gerenciador-de-plugins-vim-plug)
5. [CoC (Conquer of Completion)](#5-coc-conquer-of-completion)
6. [Referência do .vimrc](#6-referência-do-vimrc)
7. [Atalhos principais](#7-atalhos-principais)
8. [Setup inicial (do zero)](#8-setup-inicial-do-zero)
9. [Manutenção e atualização](#9-manutenção-e-atualização)
10. [Observações](#10-observações)

---

## 1. Compilação do Vim a partir do fonte

### Repositório oficial

O único repositório oficial e ativamente mantido é:

```
https://github.com/vim/vim
```

> Nunca usar forks ou mirrors de terceiros. Toda atualização, patch e release
> vem exclusivamente deste repositório.

### Dependências de compilação (Arch Linux)

Instalar antes de compilar:

```bash
sudo pacman -S \
  base-devel \
  git \
  python \
  python-pip \
  nodejs \
  npm \
  lua \
  ruby \
  libx11 \
  libxt \
  libxpm \
  ncurses \
  clang
```

| Pacote       | Por que é necessário na compilação                        |
|--------------|-----------------------------------------------------------|
| `base-devel` | gcc, make, pkg-config e toolchain completo               |
| `git`        | Clonar e atualizar o repositório do Vim                  |
| `python`     | Suporte a Python 3 (`--enable-python3interp`)            |
| `nodejs`     | Runtime do CoC (não entra no configure, mas é necessário)|
| `lua`        | Suporte a Lua (`--enable-luainterp`)                     |
| `ruby`       | Suporte a Ruby (`--enable-rubyinterp`)                   |
| `libx11`     | Suporte X11 para clipboard (`+xterm_clipboard`)          |
| `libxt`      | Suporte X11 para clipboard                               |
| `libxpm`     | Suporte a imagens no terminal (opcional)                 |
| `ncurses`    | Interface TUI do Vim                                     |
| `clang`      | Compilador C/C++ + inclui o `clangd` (LSP)              |

### Clonar o repositório

```bash
mkdir -p ~/src
git clone https://github.com/vim/vim.git ~/src/vim
cd ~/src/vim
```

### Configurar a compilação

O `./configure` abaixo habilita **todas as features necessárias** para o `.vimrc`
desta configuração funcionar corretamente:

```bash
./configure \
  --with-features=huge \
  --enable-multibyte \
  --enable-python3interp=yes \
  --with-python3-config-dir=$(python3-config --configdir) \
  --enable-luainterp=yes \
  --enable-rubyinterp=yes \
  --enable-cscope \
  --enable-terminal \
  --enable-autoservername \
  --gui=no \
  --with-x \
  --enable-xim \
  --with-compiledby="$(whoami)" \
  --prefix=/usr/local
```

#### O que cada flag habilita

| Flag | Por que é necessária |
|------|----------------------|
| `--with-features=huge` | Conjunto máximo de features (syntax, autocmd, signs, etc.) |
| `--enable-multibyte` | Suporte a UTF-8 e caracteres multibyte |
| `--enable-python3interp=yes` | Suporte a Python 3 — requerido por vários plugins |
| `--with-python3-config-dir` | Aponta para a instalação correta do Python no sistema |
| `--enable-luainterp=yes` | Suporte a Lua — usado por plugins modernos |
| `--enable-rubyinterp=yes` | Suporte a Ruby (completa o `huge`) |
| `--enable-cscope` | Navegação de código C com cscope |
| `--enable-terminal` | Terminal embutido (`:terminal`) |
| `--enable-autoservername` | Identifica instâncias do Vim (útil para plugins e scripts) |
| `--with-x` | Habilita integração com X11 |
| `--enable-xim` | Input method X11 (caracteres especiais) |
| `--prefix=/usr/local` | Instala em `/usr/local/bin/vim`, sem sobrescrever o pacman |

> **Verificar features após compilar:**
> ```bash
> vim --version | grep -E '\+python3|\+lua|\+terminal|\+clipboard'
> ```
> Todas devem aparecer com `+`. Um `-` indica que faltou alguma dependência
> antes do configure.

### Compilar e instalar

```bash
# Compilar usando todos os núcleos disponíveis
make -j$(nproc)

# Instalar
sudo make install

# Verificar
vim --version | head -2
which vim   # deve retornar /usr/local/bin/vim
```

### Nota sobre o `--prefix`

- `--prefix=/usr/local` instala o Vim compilado **sem conflitar** com o `vim`
  do pacman (que fica em `/usr/bin/vim`).
- O shell usará `/usr/local/bin/vim` automaticamente pois `/usr/local/bin`
  precede `/usr/bin` no `$PATH` padrão do Arch.
- Para confirmar: `echo $PATH` deve listar `/usr/local/bin` antes de `/usr/bin`.

---

## 2. Estrutura de arquivos

```
~/
├── .vimrc                        # Configuração principal do Vim
│
├── src/
│   └── vim/                      # Repositório clonado (github.com/vim/vim)
│       └── src/                  # Código-fonte (onde rodar make)
│
└── .vim/
    ├── autoload/
    │   └── plug.vim              # vim-plug: gerenciador de plugins
    ├── plugged/                  # Plugins instalados pelo vim-plug
    │   ├── coc.nvim/             # Motor LSP e autocomplete
    │   ├── auto-pairs/           # Fecha (, [, {, ", ' automaticamente
    │   ├── vim-polyglot/         # Syntax highlighting para +100 linguagens
    │   ├── nerdtree/             # Explorador de arquivos lateral
    │   ├── fzf/                  # Fuzzy finder (binário)
    │   ├── fzf.vim/              # Integração do fzf com o Vim
    │   ├── vim-airline/          # Status bar informativa
    │   ├── vim-airline-themes/   # Temas para o airline
    │   ├── vim-fugitive/         # Integração com Git
    │   ├── vim-commentary/       # Comentar/descomentar com gc
    │   ├── vim-surround/         # Manipular delimitadores (, ", tags
    │   ├── indentLine/           # Guias visuais de indentação
    │   └── gruvbox/              # Colorscheme
    ├── undodir/                  # Histórico de undo persistente entre sessões
    └── (gerados pelo CoC automaticamente)
        ├── coc-settings.json     # Configuração do CoC (editar com :CocConfig)
        └── extensions/           # Extensões LSP do CoC
            ├── coc-clangd/       # LSP para C/C++
            ├── coc-json/         # LSP para JSON
            ├── coc-yaml/         # LSP para YAML
            └── coc-sh/           # LSP para Shell script
```

### Por projeto (C/C++)

```
<projeto>/
└── compile_commands.json         # Contexto de compilação para o clangd
```

Gerado via:

```bash
# CMake
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .

# Qualquer build system (requer bear)
bear -- make
```

---

## 3. Dependências do sistema

| Pacote       | Função                                                  |
|--------------|---------------------------------------------------------|
| `base-devel` | Toolchain de compilação (gcc, make, pkg-config)         |
| `git`        | Clonar/atualizar o repositório do Vim                   |
| `clang`      | Compilador C/C++ + inclui o `clangd` (LSP)             |
| `nodejs`     | Necessário para o coc.nvim                              |
| `npm`        | Gerenciador de pacotes do Node (usado pelo CoC)         |
| `python`     | Suporte a Python 3 no Vim (`--enable-python3interp`)    |
| `lua`        | Suporte a Lua no Vim (`--enable-luainterp`)             |
| `fzf`        | Fuzzy finder usado pelo fzf.vim                         |
| `ripgrep`    | Grep rápido usado pelo `:Rg` no fzf.vim                 |
| `xclip`      | Integração do clipboard com o sistema (X11)             |
| `libx11`     | Suporte X11 para clipboard (`+xterm_clipboard`)         |
| `libxt`      | Suporte X11 para clipboard                              |
| `bear`       | Gera `compile_commands.json` para qualquer build system |

```bash
sudo pacman -S base-devel git clang nodejs npm python lua \
               fzf ripgrep xclip libx11 libxt bear
```

---

## 4. Gerenciador de plugins: vim-plug

**Instalação:**

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

**Comandos de manutenção (dentro do Vim):**

| Comando        | Ação                                           |
|----------------|------------------------------------------------|
| `:PlugInstall` | Instala plugins novos declarados no .vimrc     |
| `:PlugUpdate`  | Atualiza todos os plugins instalados           |
| `:PlugClean`   | Remove plugins deletados do .vimrc             |
| `:PlugStatus`  | Lista status de cada plugin                    |
| `:PlugUpgrade` | Atualiza o próprio vim-plug                    |

**Adicionar um novo plugin:**

1. Inserir `Plug 'autor/nome'` dentro do bloco `call plug#begin() ... call plug#end()` no `.vimrc`
2. Rodar `:PlugInstall` dentro do Vim

---

## 5. CoC (Conquer of Completion)

Motor LSP que gerencia autocomplete, diagnósticos, go-to-definition, etc.

**Extensões instaladas automaticamente** via `coc_global_extensions` no `.vimrc`:

| Extensão      | Linguagem / Função |
|---------------|--------------------|
| `coc-clangd`  | C / C++            |
| `coc-json`    | JSON               |
| `coc-yaml`    | YAML               |
| `coc-sh`      | Shell script       |

**Gerenciar extensões (dentro do Vim):**

| Comando                   | Ação                             |
|---------------------------|----------------------------------|
| `:CocInstall coc-<nome>`  | Instala uma extensão             |
| `:CocUninstall coc-<nome>`| Remove uma extensão              |
| `:CocUpdate`              | Atualiza todas as extensões      |
| `:CocConfig`              | Abre o coc-settings.json         |
| `:CocDiagnostics`         | Lista erros e warnings           |
| `:CocOutline`             | Estrutura de símbolos do arquivo |

**Adicionar suporte a uma nova linguagem:**

```vim
" Go
:CocInstall coc-go

" Python
:CocInstall coc-pyright

" Rust
:CocInstall coc-rust-analyzer
```

---

## 6. Referência do .vimrc

O `.vimrc` está em `~/.vimrc`. Abaixo, resumo de cada seção e sua finalidade.

### Plugins declarados

| Plugin                    | Função                                       |
|---------------------------|----------------------------------------------|
| `neoclide/coc.nvim`       | LSP, autocomplete, diagnósticos              |
| `jiangmiao/auto-pairs`    | Fecha pares de delimitadores automaticamente |
| `sheerun/vim-polyglot`    | Syntax highlighting para +100 linguagens     |
| `preservim/nerdtree`      | Árvore de arquivos lateral                   |
| `junegunn/fzf`            | Binário do fuzzy finder                      |
| `junegunn/fzf.vim`        | Integração do fzf com comandos Vim           |
| `vim-airline/vim-airline` | Status bar informativa                       |
| `vim-airline-themes`      | Temas para o airline                         |
| `tpope/vim-fugitive`      | Git integrado (status, commit, diff, log)    |
| `tpope/vim-commentary`    | Comentar/descomentar com `gc`                |
| `tpope/vim-surround`      | Manipular delimitadores ao redor do cursor   |
| `Yggdroot/indentLine`     | Guias visuais de indentação                  |
| `morhetz/gruvbox`         | Colorscheme                                  |

### Seções de configuração

| Seção                | O que configura                                                |
|----------------------|----------------------------------------------------------------|
| Configurações gerais | encoding, número de linha, mouse, clipboard, signcolumn        |
| Indentação e tabs    | tabstop=4, expandtab, smartindent                              |
| Busca                | incsearch, hlsearch, ignorecase, smartcase                     |
| Aparência            | termguicolors, gruvbox, airline, indentLine                    |
| Leader key           | `<Space>` como leader                                          |
| Navegação de janelas | Ctrl+h/j/k/l entre splits, redimensionar com Ctrl+setas        |
| Buffers              | `<leader>bn/bp/bd` para navegar e fechar buffers               |
| NERDTree             | Toggle, find, ignores, auto-fechar quando última janela        |
| FZF                  | Files, GFiles, Rg, Buffers, History, BLines                    |
| vim-fugitive         | Git status, commit, push, log, diff                            |
| CoC                  | Tab/Enter no autocomplete, LSP keybindings, highlight, rename  |
| Qualidade de vida    | Ctrl+S salvar, mover linhas, centralizar scroll/busca          |
| Arquivos temporários | noswapfile, nobackup, undofile em `~/.vim/undodir`             |
| Desempenho           | lazyredraw, ttyfast                                            |

### Nota sobre o colorscheme

O `colorscheme gruvbox` deve estar protegido por `try/catch` para evitar erro
na primeira execução (antes do `:PlugInstall`):

```vim
try
  colorscheme gruvbox
catch
  colorscheme desert
endtry
```

---

## 7. Atalhos principais

### Navegação

| Atalho         | Ação                              |
|----------------|-----------------------------------|
| `Space + e`    | Abrir/fechar NERDTree             |
| `Space + E`    | Revelar arquivo atual no NERDTree |
| `Space + f`    | Buscar arquivo (fzf)              |
| `Space + F`    | Buscar arquivo rastreado pelo git |
| `Space + b`    | Listar buffers abertos            |
| `Space + g`    | Grep no projeto (ripgrep)         |
| `Space + h`    | Histórico de arquivos             |
| `Space + /`    | Buscar dentro do buffer atual     |
| `Ctrl+h/j/k/l` | Navegar entre splits              |
| `Ctrl+setas`   | Redimensionar splits              |
| `Space + bn`   | Próximo buffer                    |
| `Space + bp`   | Buffer anterior                   |
| `Space + bd`   | Fechar buffer                     |

### LSP (CoC)

| Atalho        | Ação                           |
|---------------|--------------------------------|
| `gd`          | Ir para definição              |
| `gD`          | Ir para declaração             |
| `gy`          | Ir para definição de tipo      |
| `gi`          | Ir para implementação          |
| `gr`          | Ver referências                |
| `K`           | Documentação do símbolo        |
| `Space + rn`  | Renomear símbolo no projeto    |
| `Space + ca`  | Code actions / correções       |
| `Space + cf`  | Fix rápido do erro atual       |
| `Space + fmt` | Formatar arquivo               |
| `Space + cd`  | Listar diagnósticos            |
| `Space + co`  | Outline de símbolos            |
| `[g` / `]g`   | Navegar entre erros/warnings   |
| `Ctrl+Space`  | Forçar abertura do autocomplete|
| `Tab`         | Próxima sugestão               |
| `Shift+Tab`   | Sugestão anterior              |
| `Enter`       | Confirmar sugestão             |

### Edição

| Atalho          | Ação                                    |
|-----------------|-----------------------------------------|
| `gc` + movimento| Comentar (ex: `gcc` comenta linha)      |
| `cs"'`          | Trocar `"` por `'` ao redor do cursor   |
| `ds"`           | Remover `"` ao redor do cursor          |
| `ysiw"`         | Envolver palavra atual com `"`          |
| `J` / `K`       | Mover linhas selecionadas (modo visual) |
| `Ctrl+S`        | Salvar                                  |
| `Space + a`     | Selecionar tudo                         |
| `Ctrl+d`        | Rolar para baixo + centralizar cursor   |
| `Ctrl+u`        | Rolar para cima + centralizar cursor    |
| `n` / `N`       | Próximo/anterior resultado + centralizar|
| `p` (visual)    | Colar sem sobrescrever clipboard        |

### Git (vim-fugitive)

| Atalho       | Ação       |
|--------------|------------|
| `Space + gs` | Git status |
| `Space + gc` | Git commit |
| `Space + gp` | Git push   |
| `Space + gl` | Git log    |
| `Space + gd` | Git diff   |

---

## 8. Setup inicial (do zero)

```bash
# ── 1. Dependências de compilação e runtime ────────────────────────────────
sudo pacman -S base-devel git clang nodejs npm python lua \
               fzf ripgrep xclip libx11 libxt bear

# ── 2. Clonar o repositório oficial do Vim ────────────────────────────────
mkdir -p ~/src
git clone https://github.com/vim/vim.git ~/src/vim
cd ~/src/vim

# ── 3. Configurar com todas as features necessárias ───────────────────────
./configure \
  --with-features=huge \
  --enable-multibyte \
  --enable-python3interp=yes \
  --with-python3-config-dir=$(python3-config --configdir) \
  --enable-luainterp=yes \
  --enable-rubyinterp=yes \
  --enable-cscope \
  --enable-terminal \
  --enable-autoservername \
  --with-x \
  --enable-xim \
  --with-compiledby="$(whoami)" \
  --prefix=/usr/local

# ── 4. Compilar e instalar ────────────────────────────────────────────────
make -j$(nproc)
sudo make install

# Confirmar features compiladas (todas devem aparecer com +)
vim --version | grep -E '\+python3|\+lua|\+terminal|\+clipboard'

# ── 5. Estrutura de diretórios do Vim ─────────────────────────────────────
mkdir -p ~/.vim/undodir

# ── 6. Instalar o vim-plug ────────────────────────────────────────────────
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# ── 7. Copiar o .vimrc para ~/  ───────────────────────────────────────────
# (o arquivo deve estar em ~/.vimrc)

# ── 8. Instalar plugins ───────────────────────────────────────────────────
vim +PlugInstall +qa

# ── 9. Abrir o Vim — CoC instala as extensões automaticamente ─────────────
vim
```

---

## 9. Manutenção e atualização

### Atualizar o Vim (recompilar)

```bash
cd ~/src/vim
git pull

# Limpar build anterior obrigatoriamente antes de recompilar
cd src
make distclean
cd ..

# Rodar configure novamente com as mesmas flags
./configure \
  --with-features=huge \
  --enable-multibyte \
  --enable-python3interp=yes \
  --with-python3-config-dir=$(python3-config --configdir) \
  --enable-luainterp=yes \
  --enable-rubyinterp=yes \
  --enable-cscope \
  --enable-terminal \
  --enable-autoservername \
  --with-x \
  --enable-xim \
  --with-compiledby="$(whoami)" \
  --prefix=/usr/local

make -j$(nproc)
sudo make install
```

### Atualizar plugins

```vim
:PlugUpdate
```

### Atualizar extensões CoC

```vim
:CocUpdate
```

### Atualizar o vim-plug em si

```vim
:PlugUpgrade
```

---

## 10. Observações

- O `undodir` permite desfazer alterações mesmo após fechar e reabrir um arquivo. **Não apagar** esse diretório.
- O `coc-settings.json` pode ser editado com `:CocConfig` para tunar comportamento do LSP (formatação automática ao salvar, paths do clangd, etc.).
- Para projetos C/C++, sempre gerar o `compile_commands.json` na raiz do projeto para o `clangd` funcionar corretamente.
- O Vim foi compilado do código-fonte. Atualizações exigem `git pull` + `make distclean` + recompilação em `~/src/vim`.
- O `--prefix=/usr/local` garante que o Vim compilado não conflite com um eventual `vim` instalado via pacman em `/usr/bin/vim`.
- Se `vim --version` mostrar `-clipboard`, significa que as libs `libx11`/`libxt` não estavam instaladas antes do `./configure`. Reinstalar as libs e recompilar resolve.
