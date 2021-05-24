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

" 改良版
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
set wildmode=longest,list,full

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

" introを表示しない
set shortmess+=I

" Windowの設定
set noequalalways

" 検索件数の表示
set shortmess-=S

" bombを使わない(明示的に指定)
set nobomb

" 独自コマンド
command! OpenDot :cd ~/dotfiles
command! DirOpen :call job_start("open .")

function! s:auto_mkdir(dir, force)
if !isdirectory(a:dir) && (a:force ||
\    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
endif
endfunction
augroup vimrc-auto-mkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
augroup END

let mapleader = "\<Space>"

" Undoポイントの設置
inoremap <silent><C-w> <C-g>u<C-w>
inoremap <silent><C-u> <C-g>u<C-u>
inoremap <silent><C-m> <C-g>u<C-m>

" 0の挙動を調節(借りもの)
nnoremap <expr> 0 getline('.')[0 : col('.') - 2] =~# '^\s\+$' ? '0' : '^'

" バッファの切り替え
nnoremap <silent> <leader>n :bn<CR>
nnoremap <silent> <leader>p :bp<CR>

" <C-p> <C-n> でも履歴を参照する
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>

" Emacs風の移動
inoremap <silent><C-a> <Home>
inoremap <silent><C-e> <End>

" 行単位での移動
nnoremap <silent>j gj
nnoremap <silent>k gk

" 諸々の再描画
nnoremap <silent><leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:call popup_clear()<cr><c-l>

nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

tnoremap <C-y> <c-n\><c-n>

" ファイルタイプ別
autocmd FileType vue syntax sync fromstart
au BufNewFile,BufRead *.toml setf toml

"      |              o
" ,---.|    .   .,---..,---.
" |   ||    |   ||   |||   |
" |---'`---'`---'`---|``   '
" |              `---'

let s:rc_dir = expand("~/.vim/deinrc/")
let s:loads = [
            \ {"path": "color.toml", "lazy": v:false},
            \ {"path": "ferm.toml", "lazy": v:false},
            \ {"path": "general.toml", "lazy": v:false},
            \ {"path": "lsp.toml", "lazy": v:false},
            \ {"path": "dein_lazy.toml", "lazy": v:true},
            \]

" dein.vimの自動インストール
if has('vim_starting')
    let s:dein_cache_home = empty($XDG_CACHE_HOME) ? expand("~/.cache") : $XDG_CACHE_HOME
    let s:dein_dir = s:dein_cache_home .. '/vim/dein'
    let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' .. shellescape(s:dein_repo_dir))
    endif
    let &runtimepath = &runtimepath .. ',' .. s:dein_repo_dir
endif

" プラグインのインストール
if &compatible
  set nocompatible
endif
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#add(s:dein_repo_dir)
    for s:toml in s:loads
        call dein#load_toml(s:rc_dir .. s:toml['path'], {'lazy': s:toml['lazy']})
    endfor
    call dein#end()
    call dein#save_state()
endif
filetype plugin indent on
syntax enable
if dein#check_install()
    call dein#install()
endif

" github用のtoken読み出し(環境変数に入れたほうが良い?)
if has('vim_starting')
    let tokenpath = expand('$HOME/.config/github_tokens/dein.token')
    if filereadable(tokenpath)
    let token = readfile(tokenpath)
    let g:dein#install_github_api_token = token[0]
    endif
endif
