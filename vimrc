"                 o8o
"                 `"'
"    oooo    ooo oooo  ooo. .oo.  .oo.   oooo d8b  .ooooo.
"     `88.  .8'  `888  `888P"Y88bP"Y88b  `888""8P d88' `"Y8
"      `88..8'    888   888   888   888   888     888
".o.    `888'     888   888   888   888   888     888   .o8
"Y8P     `8'     o888o o888o o888o o888o d888b    `Y8bod8P'
set nocompatible

" encoding
set encoding=utf-8
scriptencoding utf-8
set t_ZH=
set termguicolors

" 行番号・行のライン
set number
set cursorline

" ステータスライン
set laststatus=2
set noshowmode

" 文字コード
set fileencoding=utf-8
scriptencoding utf-8
set ambiwidth=double

" サーチの設定
set incsearch
set ignorecase
set smartcase
set hlsearch

" バッファ
set hidden

" タブの扱い
set tabstop=4
set shiftwidth=4
set softtabstop=0
set expandtab
set smarttab
set shiftround

" for complete
set completeopt+=menuone,menu,preview
set pumheight=12

" シンタックスハイライトを使う
syntax enable

" for command mode
set wildmenu
set wildmode=longest:full,full

" window
set noequalalways

" 検索件数の表示
set shortmess-=S

let mapleader = "\<Space>"

" Undoポイントの設置
inoremap <silent><C-w> <C-g>u<C-w>
inoremap <silent><C-u> <C-g>u<C-u>
inoremap <silent><C-m> <C-g>u<C-m>

" Enable mouse
set mouse=a
set ttymouse=sgr

set whichwrap=b,s,h,l,<,>,[,]
set backspace=indent,eol,start

" 保存
cabbr w!! w !sudo tee > /dev/null %

" 設定ファイルを読み込む
function! OpenRcFiles()
  edit ~/.vim/deinrc/dein.toml
  edit ~/.vim/deinrc/dein_lazy.toml
  edit ~/.vimrc
endfunction
command! Preference call OpenRcFiles()

" <esc>の反応
set ttimeoutlen=10

" Swapを作らない + 外部の変更を取り込む
set nobackup
set noswapfile
set autoread

" 入力中のコマンドを表示
set showcmd

" 0の挙動を調節(借りもの)
nnoremap <expr> 0 getline('.')[0 : col('.') - 2] =~# '^\s\+$' ? '0' : '^'

" バッファの切り替え
nnoremap <silent> <leader>n :bn<CR>
nnoremap <silent> <leader>p :bp<CR>

if (exists('+colorcolumn'))
  set colorcolumn=80
endif

augroup vimrc-auto-mkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force ||
    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END

let s:stop_time = 10

function! s:down(timer) abort
  execute "normal! 3\<C-e>3j"
endfunction

function! s:up(timer) abort
  execute "normal! 3\<C-y>3k"
endfunction

function! s:smooth_scroll(fn) abort
  let working_timer = get(s:, 'smooth_scroll_timer', 0)
  if !empty(timer_info(working_timer))
    call timer_stop(working_timer)
  endif
  if (a:fn ==# 'down' && line('$') == line('w$')) ||
        \ (a:fn ==# 'up' && line('w0') == 1)
    return
  endif
  let s:smooth_scroll_timer = timer_start(s:stop_time, function('s:' . a:fn), {'repeat' : &scroll/3})
endfunction

nnoremap <silent> <C-u> <cmd>call <SID>smooth_scroll('up')<CR>
nnoremap <silent> <C-d> <cmd>call <SID>smooth_scroll('down')<CR>
vnoremap <silent> <C-u> <cmd>call <SID>smooth_scroll('up')<CR>
vnoremap <silent> <C-d> <cmd>call <SID>smooth_scroll('down')<CR>

" quickfix
au FileType qf nnoremap <silent><buffer>q :quit<CR>
autocmd QuickFixCmdPost *grep* cwindow

" introの非表示
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

set shortmess+=I

autocmd WinLeave * if &buftype == "terminal" | silent! execute "normal! i" | endif
autocmd TerminalOpen * if &buftype == "terminal" | silent! set nobuflisted | endif

let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
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
filetype plugin indent on
syntax enable
" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

let tokenpath = expand('$HOME/.config/github_tokens/dein.token')
if filereadable(tokenpath)
  let token = readfile(tokenpath)
  let g:dein#install_github_api_token = token[0]
endif
" End dein Scripts-------------------------

" For Vue
autocmd FileType vue syntax sync fromstart

packadd termdebug
