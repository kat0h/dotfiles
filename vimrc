" _    _ _____ _______  ______ _______
"   \  /    |   |  |  | |_____/ |
"    \/   __|__ |  |  | |    \_ |_____
"

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set nobomb

set ambiwidth=single
set number
syntax enable
set termguicolors
set t_ZH=
set t_ZR=
set t_ut=
set cursorline
let mapleader = "\<Space>"

set expandtab
set shiftround
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=0
set autoindent
set tabstop=2
set list
set listchars=tab:>.,trail:_
set scrolloff=10

set incsearch
set ignorecase
set smartcase
set hlsearch

" マウス
set mouse=a
set ttymouse=sgr

" 外でのファイル変更を自動適用
set autoread
" バックスペースの挙動
set backspace=indent,start,eol
set whichwrap=b,s,h,l,<,>,[,]
set hidden
" Windowサイズの自動調節をオフ
set noequalalways
set shortmess+=I
set shortmess+=c

" Swap Fileを作らない
set noswapfile
set nobackup
set nowritebackup

set ttimeoutlen=10
set belloff=all


" 使ってないんだからオフにしたっていいよね
let g:loaded_2html_plugin      = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_netrw             = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1

source ~/.vim/jetpack_install.vim
source ~/.vim/plugin_install.vim

source ~/.vim/keymap.vim
source ~/.vim/utils.vim
source ~/.vim/plugin_setting.vim
