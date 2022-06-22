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

set incsearch
set ignorecase
set smartcase
set hlsearch
nnoremap <expr> N 'nN'[v:searchforward]
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <Esc><Esc> :nohlsearch<Cr>

" マウス
set mouse=a
if !has('nvim')
  set ttymouse=sgr
endif

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

" 強制書き込み
cabbr w!! w !sudo tee > /dev/null %
" 自動mkdir
function! s:auto_mkdir(dir, force) abort
  if !isdirectory(a:dir) && (a:force ||
        \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
augroup VimrcAutoMakedir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
augroup END

" emacs風キーバインド
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

inoremap <C-a> <Home>
inoremap <C-b> <Left>
inoremap <C-e> <End>
inoremap <C-f> <Right>
inoremap <C-n> <Down>
inoremap <C-p> <Up>

" 便利なウィンドウ移動
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l
nnoremap <silent> <C-q> <C-w>q

" zero
nnoremap <expr> 0 getline('.')[0 : col('.') - 2] =~# '^\s\+$' ? '0' : '^'

" 色々クリア
nnoremap <silent><leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:call popup_clear()<cr><c-l>

" 表示行ごとに移動
nnoremap <silent>j gj
nnoremap <silent>k gk

" Visualで行末まで
vnoremap v $h

" jjでノーマルに
inoremap <expr> j getline('.')[col('.') - 2] ==# 'j' ? "\<BS>\<ESC>" : 'j'

" 便利な貼り付け
nnoremap p ]p
nnoremap P ]P
nnoremap ]p p
nnoremap ]P P

" Undoポイントを貼り付ける
inoremap <silent><C-w> <C-g>u<C-w>
inoremap <silent><C-u> <C-g>u<C-u>
inoremap <silent><C-m> <C-g>u<C-m>

" シュッと
nnoremap <silent> <leader>n :bn<CR>
nnoremap <silent> <leader>p :bp<CR>

" 全行ハイライト
augroup VimrcFileType
  autocmd!
  autocmd FileType vue syntax sync fromstart
  autocmd FileType html syntax sync fromstart
augroup END

" シュッと開くやつ
command! VIM silent e ~/.vimrc | cd ~/dotfiles
command! -nargs=1 -complete=file Open :call system("open".." '<args>'")

" denoでシュッとリダイレクト先を探す
function! GetRedirectUrl(url) abort
  let r = system('curl -w "%{redirect_url}" -s -o /dev/null ' .. shellescape(a:url))
  if r == ""
    return a:url
  endif
  return r
endfunction
vnoremap r c<C-r>=GetRedirectUrl(@")<CR><esc>

if !has('nvim')
let s:cell = [
      \]
let s:cellwidths = []
  for i in s:cell
    let s:c = char2nr(i[0])
    call add(s:cellwidths, [s:c, s:c, i[1]])
  endfor
  call setcellwidths(s:cellwidths)
endif

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

if !filereadable(expand("~/.vim/autoload/jetpack.vim"))
  call system('curl -fLo ~/.vim/autoload/jetpack.vim --create-dirs https://raw.githubusercontent.com/tani/vim-jetpack/master/autoload/jetpack.vim')
endif
let g:jetpack#optimization = 0

source ~/.vim/plugin_install.vim
source ~/.vim/plugin_setting.vim
