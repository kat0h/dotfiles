"                 o8o
"                 `"'
"    oooo    ooo oooo  ooo. .oo.  .oo.   oooo d8b  .ooooo.
"     `88.  .8'  `888  `888P"Y88bP"Y88b  `888""8P d88' `"Y8
"      `88..8'    888   888   888   888   888     888
".o.    `888'     888   888   888   888   888     888   .o8
"Y8P     `8'     o888o o888o o888o o888o d888b    `Y8bod8P'

set encoding=utf-8
scriptencoding utf-8

"行番号・行のライン
set number
set cursorline
set cursorlineopt=number

" ステータスライン
set laststatus=2
set noshowmode

"文字コード
set fileencoding=utf-8
scriptencoding utf-8
set ambiwidth=double

"インデント
set smartindent

"サーチ
set incsearch
set ignorecase
set smartcase
set hlsearch
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

"バッファ
set hidden

"タブの扱い
set tabstop=4
set shiftwidth=4
set softtabstop=0
set expandtab
set smarttab
set shiftround

"for complete
set completeopt+=menuone,menu,preview
set pumheight=12

"Use syntax highlight
syntax enable

"for backspaceKey
set backspace=indent,eol,start

"for command mode
set wildmenu

"window
set noequalalways

"検索件数の表示
set shortmess-=S

"Undoポイントの設置
inoremap <silent><C-w> <C-g>u<C-w>
inoremap <silent><C-u> <C-g>u<C-u>
inoremap <silent><C-m> <C-g>u<C-m>
inoremap <silent><C-j> <C-g>u<C-j>

nnoremap <silent><C-n> <Esc>:bn<CR>
nnoremap <silent><C-p> <Esc>:bp<CR>

" Enable mouse
set mouse=a

autocmd FileType vue syntax sync fromstart

nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>
nnoremap <silent><Left> <C-w>h
nnoremap <silent><Right> <C-w>l
nnoremap <silent><Up> <C-w>j
nnoremap <silent><Down> <C-w>j

cabbr w!! w !sudo tee > /dev/null %

let mapleader = "\<Space>"

" ______  _______ _____ __   _   _    _ _____ _______
" |     \ |______   |   | \  |    \  /    |   |  |  |
" |_____/ |______ __|__ |  \_| .   \/   __|__ |  |  |
"dein Scripts-----------------------------
" dein自体の自動インストール
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
" Required:
set runtimepath+=/Users/katokota/.vim/./dein/repos/github.com/Shougo/dein.vim
" Required:
if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')
    "Let dein manage dein
   " Required:
    call dein#add('~/.cache/dein')
    let g:rc_dir = '~/dotfiles/vim/deinrc'
    let s:toml      = g:rc_dir . '/dein.toml'
    let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    " Required:
    call dein#end()
    call dein#save_state()
endif
" Required:
filetype plugin indent on
syntax enable
" If you want to install not installed plugins on startup.
if dein#check_install()
    call dein#install()
endif
"End dein Scripts-------------------------
"For dein
function! s:DeinCleanf()
    call map(dein#check_clean(), "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
endfunction

command! DeinCheckInstall call dein#check_install()
command! DeinCheckClean call dein#check_clean()
command! DeinUpdate call dein#update()
