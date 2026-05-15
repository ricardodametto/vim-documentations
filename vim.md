# Vim — Documentação do Ambiente

Configuração do Vim como IDE para C/C++ e uso geral no Arch Linux.

---

## Estrutura de arquivos

```
~/
├── .vimrc                        # Configuração principal do Vim
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

## Dependências do sistema

Instaladas via pacman:

| Pacote       | Função                                          |
|--------------|-------------------------------------------------|
| `vim`        | Editor (compilado do fonte, repositório GitHub) |
| `clang`      | Compilador C/C++ + inclui o `clangd` (LSP)     |
| `nodejs`     | Necessário para o coc.nvim                      |
| `npm`        | Gerenciador de pacotes do Node (usado pelo CoC) |
| `fzf`        | Fuzzy finder usado pelo fzf.vim                 |
| `ripgrep`    | Grep rápido usado pelo `:Rg` no fzf.vim         |
| `xclip`      | Integração do clipboard com o sistema (X11)     |

```bash
sudo pacman -S clang nodejs npm fzf ripgrep xclip
```

---

## Gerenciador de plugins: vim-plug

**Instalação:**

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

**Comandos de manutenção (dentro do Vim):**

| Comando          | Ação                                              |
|------------------|---------------------------------------------------|
| `:PlugInstall`   | Instala plugins novos declarados no .vimrc        |
| `:PlugUpdate`    | Atualiza todos os plugins instalados              |
| `:PlugClean`     | Remove plugins deletados do .vimrc                |
| `:PlugStatus`    | Lista status de cada plugin                       |
| `:PlugUpgrade`   | Atualiza o próprio vim-plug                       |

**Adicionar um novo plugin:**

1. Inserir `Plug 'autor/nome'` dentro do bloco `call plug#begin() ... call plug#end()` no `.vimrc`
2. Rodar `:PlugInstall` dentro do Vim

---

## CoC (Conquer of Completion)

Motor LSP que gerencia autocomplete, diagnósticos, go-to-definition, etc.

**Extensões instaladas automaticamente** via `coc_global_extensions` no `.vimrc`:

| Extensão      | Linguagem / Função     |
|---------------|------------------------|
| `coc-clangd`  | C / C++                |
| `coc-json`    | JSON                   |
| `coc-yaml`    | YAML                   |
| `coc-sh`      | Shell script           |

**Gerenciar extensões (dentro do Vim):**

| Comando                        | Ação                          |
|--------------------------------|-------------------------------|
| `:CocInstall coc-<nome>`       | Instala uma extensão          |
| `:CocUninstall coc-<nome>`     | Remove uma extensão           |
| `:CocUpdate`                   | Atualiza todas as extensões   |
| `:CocConfig`                   | Abre o coc-settings.json      |
| `:CocDiagnostics`              | Lista erros e warnings        |
| `:CocOutline`                  | Estrutura de símbolos do arquivo |

**Adicionar suporte a uma nova linguagem:**

```bash
# Exemplo: Go
:CocInstall coc-go

# Exemplo: Python
:CocInstall coc-pyright

# Exemplo: Rust
:CocInstall coc-rust-analyzer
```

---

## Atalhos principais

### Navegação

| Atalho          | Ação                              |
|-----------------|-----------------------------------|
| `Space + e`     | Abrir/fechar NERDTree             |
| `Space + E`     | Revelar arquivo atual no NERDTree |
| `Space + f`     | Buscar arquivo (fzf)              |
| `Space + F`     | Buscar arquivo rastreado pelo git |
| `Space + b`     | Listar buffers abertos            |
| `Space + g`     | Grep no projeto (ripgrep)         |
| `Space + h`     | Histórico de arquivos             |
| `Ctrl+h/j/k/l`  | Navegar entre splits              |

### LSP (CoC)

| Atalho          | Ação                              |
|-----------------|-----------------------------------|
| `gd`            | Ir para definição                 |
| `gD`            | Ir para declaração                |
| `gi`            | Ir para implementação             |
| `gr`            | Ver referências                   |
| `K`             | Documentação do símbolo           |
| `Space + rn`    | Renomear símbolo no projeto       |
| `Space + ca`    | Code actions / correções          |
| `Space + fmt`   | Formatar arquivo                  |
| `Space + cd`    | Listar diagnósticos               |
| `[g` / `]g`     | Navegar entre erros/warnings      |

### Edição

| Atalho          | Ação                                        |
|-----------------|---------------------------------------------|
| `gc` + movimento| Comentar (ex: `gcc` comenta linha)          |
| `cs"'`          | Trocar `"` por `'` ao redor do cursor       |
| `ds"`           | Remover `"` ao redor do cursor              |
| `ysiw"`         | Envolver palavra atual com `"`              |
| `J` / `K`       | Mover linhas selecionadas (modo visual)     |
| `Ctrl+S`        | Salvar                                      |
| `Space + a`     | Selecionar tudo                             |

### Git (vim-fugitive)

| Atalho          | Ação              |
|-----------------|-------------------|
| `Space + gs`    | Git status        |
| `Space + gc`    | Git commit        |
| `Space + gp`    | Git push          |
| `Space + gl`    | Git log           |
| `Space + gd`    | Git diff          |

---

## Setup inicial (do zero)

```bash
# 1. Dependências
sudo pacman -S clang nodejs npm fzf ripgrep xclip

# 2. vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 3. Diretório de undo persistente
mkdir -p ~/.vim/undodir

# 4. Instalar plugins
vim +PlugInstall +qa

# 5. Abrir normalmente — CoC instala as extensões automaticamente
vim
```

---

## Observações

- O `undodir` permite desfazer alterações mesmo após fechar e reabrir um arquivo. Não apagar esse diretório.
- O `coc-settings.json` pode ser editado com `:CocConfig` para tunar comportamento do LSP (ex: formatação automática ao salvar, paths do clangd, etc.).
- Para projetos C/C++, sempre gerar o `compile_commands.json` na raiz do projeto para o `clangd` funcionar corretamente.
- O Vim foi compilado do código fonte. Atualizações exigem `git pull` + recompilação no diretório do repositório clonado.
