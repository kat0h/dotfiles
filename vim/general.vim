" デフォルトのプラグインをオフにする
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1

" エンコーディングの設定
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set ambiwidth=double

" Be Improved
set nocompatible

" 行番号・行のライン
set number
set cursorline

" シンタックスハイライト
syntax enable

" 補完
set completeopt+=menuone,menu,preview
set pumheight=12

" タブの扱い
set tabstop=2
set shiftwidth=2
set softtabstop=0
set expandtab
set smarttab
set smartindent
set smartcase
set shiftround

" サーチの設定
set incsearch
set ignorecase
set smartcase
set hlsearch

" for command mode
set wildmenu
set wildmode=longest:full,full

" ターミナルの設定
set termguicolors
set t_ZH=
set t_ZR=

" マウスを使う
set mouse=a
if !has('nvim')
    set ttymouse=sgr
endif

" 新しいバッファを開く時に警告を表示しない
set hidden

" Swapファイルを作らない
set nobackup
set noswapfile
set nowritebackup

" 外部の変更を自動で反映する
set autoread

" 入力中のコマンドを表示
set showcmd

" 80文字目に目印をつける
if exists('+colorcolumn')
  set colorcolumn=80
endif

" 保存
cabbr w!! w !sudo tee > /dev/null %

" カーソルの挙動
set whichwrap=b,s,h,l,<,>,[,]
set backspace=indent,eol,start
set iskeyword+=-
set autoindent

" Quickfix
au FileType qf nnoremap <silent><buffer>q :quit<CR>
autocmd QuickFixCmdPost *grep* cwindow

" ターミナル
autocmd WinLeave * if &buftype == "terminal" | silent! execute "normal! i" | endif
if !has('nvim')
    autocmd TerminalOpen * if &buftype == "terminal" | silent! set nobuflisted | endif
endif

" Introを表示しない
set shortmess+=I

" Windowの設定
set noequalalways

" 検索件数の表示
set shortmess-=S

" bombを使わない(明示的に指定)
set nobomb

command! OpenDot :cd ~/dotfiles
