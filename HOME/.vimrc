"行号・行のライン
"set number
"set cursorline

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
"set hidden

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

"for typo
cnoremap Q q

"for terminalMod
set splitbelow
set termwinsize=7x0

"dein Scripts-----------------------------
if &compatible
    set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/katokota/.vim/./dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/katokota/.vim/./dein')
    call dein#begin('/Users/katokota/.vim/./dein')

    " Let dein manage dein
    " Required:
    call dein#add('/Users/katokota/.vim/./dein/repos/github.com/Shougo/dein.vim')

    " Add or remove your plugins here like this:
    "call dein#add('Shougo/neosnippet.vim')
    "call dein#add('Shougo/neosnippet-snippets')

    call dein#add('w0rp/ale')
    call dein#add('itchyny/vim-parenmatch')
    call dein#add('qpkorr/vim-bufkill')
    call dein#add('junegunn/fzf.vim')
    call dein#add('tomtom/tcomment_vim')
    call dein#add('bronson/vim-trailing-whitespace')
    call dein#add('Yggdroot/indentLine')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('yuttie/comfortable-motion.vim')

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

"カッコのハイライト標準オフ
let g:loaded_matchparen = 1
""カッコの対応
source $VIMRUNTIME/macros/matchit.vim
"ALEの設定
"let g:airline#extensions#ale#enabled = 1
""let g:ale_sign_column_always = 1
let g:ale_sign_error   = '!}'
let g:ale_sign_warning = '?}'
"タイムアウト時間の調整
"let g:ale_lint_delay = 1000
""help日本語化
set helplang=ja,en
" fzf
" If installed using Homebrew
set rtp+=/usr/local/opt/fzf
nmap \b :Buffers<Enter>
nmap \f :Files<Enter>
nmap \t :Tags<Enter>
let g:indent_guides_guide_size = 1

