"                 o8o
"                 `"'
"    oooo    ooo oooo  ooo. .oo.  .oo.   oooo d8b  .ooooo.
"     `88.  .8'  `888  `888P"Y88bP"Y88b  `888""8P d88' `"Y8
"      `88..8'    888   888   888   888   888     888
".o.    `888'     888   888   888   888   888     888   .o8
"Y8P     `8'     o888o o888o o888o o888o d888b    `Y8bod8P'

"行号・行のライン
"set number
set cursorline

"文字コード
set encoding=utf-8
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
"nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>
"set whichwrap=b,s,h,l,<,>,[,],~

"バッファ
set hidden

"タブの扱い
set tabstop=4
set shiftwidth=4
set softtabstop=0
set expandtab
set smarttab
set shiftround

"ColorScheme
colorscheme molokai

"Show Mode
"set noshowmode

"Use mouse
set mouse=a
set ttymouse=sgr

"Use syntax highlight
syntax  enable

"for terminalMod
set splitbelow
" set termwinsize=10x0

"for backspaceKey
set backspace=indent,eol,start

"for command mode
set wildmenu

"window
set noequalalways

"検索件数の表示
set shortmess-=S

"Undoポイントの設置
inoremap <C-w> <C-g>u<C-w>
inoremap <C-d> <Delete>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-m> <C-g>u<C-m>
inoremap <C-j> <C-g>u<C-j>

"dein Scripts-----------------------------
if &compatible
    set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/katokota/.vim/./dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/katokota/.vim/./dein')
    call dein#begin('/Users/katokota/.vim/./dein')
    "Let dein manage dein
    " Required:
    call dein#add('/Users/katokota/.vim/./dein/repos/github.com/Shougo/dein.vim')

    let g:rc_dir = $HOME . '/.vim/deinrc'
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

command! DeinClean call:DeinCleanf()
