call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()
" ============================================================
"  .vimrc - Configuração completa (IDE-like)
"  Dependências: vim-plug, clangd, fzf, ripgrep, node.js (coc)
" ============================================================


" ------------------------------------------------------------
"  PLUGINS (vim-plug)
" ------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" LSP + autocomplete (requer Node.js)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Autopairs: fecha (, [, {, ', " automaticamente
Plug 'jiangmiao/auto-pairs'

" Syntax highlighting para +100 linguagens
Plug 'sheerun/vim-polyglot'

" Explorador de arquivos lateral
Plug 'preservim/nerdtree'

" Fuzzy finder (busca de arquivos e conteúdo)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Status bar informativa
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git: blame, diff, log, etc.
Plug 'tpope/vim-fugitive'

" gc / gcc para comentar linha ou bloco
Plug 'tpope/vim-commentary'

" cs"' troca aspas; ds" remove; ysiw" envolve palavra
Plug 'tpope/vim-surround'

" Guias de indentação visuais
Plug 'Yggdroot/indentLine'

" Colorscheme
Plug 'morhetz/gruvbox'

call plug#end()


" ------------------------------------------------------------
"  CONFIGURAÇÕES GERAIS
" ------------------------------------------------------------
set nocompatible             " desativa modo vi legado
filetype plugin indent on    " detecção de tipo de arquivo
syntax on                    " syntax highlighting

set encoding=utf-8
set fileencoding=utf-8

set number                   " número de linha absoluto
set relativenumber           " número relativo (navegar com j/k)
set cursorline               " destaca linha atual
set colorcolumn=100          " coluna de aviso de comprimento

set mouse=a                  " suporte ao mouse
set clipboard=unnamedplus    " compartilha clipboard com o sistema (requer xclip/wl-clipboard)

set hidden                   " permite trocar buffer sem salvar
set confirm                  " pergunta antes de descartar alterações

set updatetime=300           " delay menor (usado pelo coc para diagnósticos)
set signcolumn=yes           " sempre mostra coluna de sinais (erros, git)
set shortmess+=c             " sem mensagens de autocomplete no rodapé


" ------------------------------------------------------------
"  INDENTAÇÃO E TABS
" ------------------------------------------------------------
set tabstop=4                " tab visual = 4 espaços
set shiftwidth=4             " indentação automática = 4 espaços
set softtabstop=4
set expandtab                " converte tab em espaços
set smartindent              " indentação inteligente para código
set autoindent


" ------------------------------------------------------------
"  BUSCA
" ------------------------------------------------------------
set incsearch                " busca incremental enquanto digita
set hlsearch                 " destaca resultados
set ignorecase               " busca case-insensitive...
set smartcase                " ...exceto quando há maiúsculas na query
" Limpar highlight com <Esc>
nnoremap <Esc> :nohlsearch<CR>


" ------------------------------------------------------------
"  APARÊNCIA
" ------------------------------------------------------------
set termguicolors            " cores 24-bit (requer terminal compatível)
set background=dark
" no lugar das linhas de aparência atuais, troque por:
try
  colorscheme gruvbox
catch
  colorscheme desert       " fallback nativo do vim
endtry

" Airline
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 0   " mude para 1 se tiver Nerd Font instalada
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#branch#enabled = 1

" IndentLine
let g:indentLine_char = '│'
let g:indentLine_enabled = 1


" ------------------------------------------------------------
"  LEADER KEY
" ------------------------------------------------------------
let mapleader = " "          " Espaço como leader


" ------------------------------------------------------------
"  NAVEGAÇÃO DE JANELAS
" ------------------------------------------------------------
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Redimensionar splits
nnoremap <C-Up>    :resize +2<CR>
nnoremap <C-Down>  :resize -2<CR>
nnoremap <C-Left>  :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>


" ------------------------------------------------------------
"  BUFFERS
" ------------------------------------------------------------
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>


" ------------------------------------------------------------
"  NERDTREE
" ------------------------------------------------------------
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>E :NERDTreeFind<CR>     " revela arquivo atual na árvore

let NERDTreeShowHidden = 1              " mostra arquivos ocultos
let NERDTreeIgnore = ['\.git$', 'node_modules', '__pycache__', '\.o$', '\.pyc$']

" Fecha o Vim se NERDTree for a única janela restante
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 &&
  \ exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif


" ------------------------------------------------------------
"  FZF (fuzzy finder)
"  Requer: fzf e ripgrep instalados no sistema
" ------------------------------------------------------------
nnoremap <leader>f  :Files<CR>          " busca de arquivos
nnoremap <leader>F  :GFiles<CR>         " arquivos rastreados pelo git
nnoremap <leader>g  :Rg<CR>            " busca de conteúdo (ripgrep)
nnoremap <leader>b  :Buffers<CR>        " lista de buffers abertos
nnoremap <leader>h  :History<CR>        " histórico de arquivos
nnoremap <leader>/  :BLines<CR>         " busca na linha do buffer atual


" ------------------------------------------------------------
"  VIM-FUGITIVE (git)
" ------------------------------------------------------------
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git log --oneline<CR>
nnoremap <leader>gd :Gdiffsplit<CR>


" ------------------------------------------------------------
"  COC.NVIM - LSP, Autocomplete, Diagnósticos
" ------------------------------------------------------------

" Extensões instaladas automaticamente
let g:coc_global_extensions = [
  \ 'coc-clangd',
  \ 'coc-json',
  \ 'coc-yaml',
  \ 'coc-sh',
  \ ]

" Tab navega nas sugestões do autocomplete
inoremap <silent><expr> <Tab>
  \ coc#pum#visible() ? coc#pum#next(1) :
  \ CheckBackspace() ? "\<Tab>" :
  \ coc#refresh()
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

" Enter confirma a sugestão selecionada
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm()
  \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Ctrl+Space força abrir autocomplete
inoremap <silent><expr> <C-Space> coc#refresh()

" Navegar entre diagnósticos (erros/warnings)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Ações de LSP
nmap <silent> gd <Plug>(coc-definition)           " ir para definição
nmap <silent> gD <Plug>(coc-declaration)          " ir para declaração
nmap <silent> gy <Plug>(coc-type-definition)      " tipo da definição
nmap <silent> gi <Plug>(coc-implementation)       " implementação
nmap <silent> gr <Plug>(coc-references)           " referências

" Documentação / hover (K mostra info do símbolo)
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Renomear símbolo em todo o projeto
nmap <leader>rn <Plug>(coc-rename)

" Code actions (correções automáticas)
nmap <leader>ca <Plug>(coc-codeaction-cursor)
nmap <leader>cf <Plug>(coc-fix-current)

" Formatar arquivo inteiro
nnoremap <leader>fmt :call CocAction('format')<CR>

" Listar diagnósticos / símbolos do projeto
nnoremap <leader>cd :CocDiagnostics<CR>
nnoremap <leader>co :CocOutline<CR>

" Highlight de referências do símbolo sob o cursor
autocmd CursorHold * silent call CocActionAsync('highlight')


" ------------------------------------------------------------
"  ATALHOS GERAIS DE QUALIDADE DE VIDA
" ------------------------------------------------------------

" Salvar com Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Fechar buffer sem fechar janela
nnoremap <leader>q :bdelete<CR>

" Selecionar tudo
nnoremap <leader>a ggVG

" Mover linhas selecionadas para cima/baixo (modo visual)
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Centralizar cursor ao rolar com Ctrl+d/u
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Centralizar ao buscar
nnoremap n nzzzv
nnoremap N Nzzzv

" Não sobrescrever o clipboard ao colar em cima de seleção
vnoremap p "_dP


" ------------------------------------------------------------
"  ARQUIVOS TEMPORÁRIOS
" ------------------------------------------------------------
set noswapfile
set nobackup
set nowritebackup
set undofile                         " histórico de undo persistente entre sessões
set undodir=~/.vim/undodir
" Cria o diretório se não existir:
" mkdir -p ~/.vim/undodir


" ------------------------------------------------------------
"  DESEMPENHO
" ------------------------------------------------------------
set lazyredraw               " não redesenha durante macros
set ttyfast                  " transmissão rápida para o terminal
