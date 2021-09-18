" _    _ _____ _______  ______ _______
"   \  /    |   |  |  | |_____/ |
"    \/   __|__ |  |  | |    \_ |_____
"

" Encoding
" ----------------------------------------------------------------------------
" {{{
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set nobomb
"}}}
" Install Plugins
" -----------------------------------------------------------------------------
" Automatically install Plug.vim {{{
let s:plugCache = expand("~/.cache/plug")
if has('vim_starting')
  if !isdirectory(s:plugCache)
    call mkdir(s:plugCache, "p")
    call system("curl -fLo "
          \.. shellescape(s:plugCache .. "/plug.vim")
          \.. " https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
  endif
  execute ":source " ..  s:plugCache .. "/plug.vim"
endif "}}}
" Install plugins {{{
" Todo
" [ ] Go周りのプラグイン
call plug#begin(s:plugCache)
Plug 'cespare/vim-toml'
Plug 'dracula/vim'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-parenmatch'
Plug 'itchyny/vim-winfix'
Plug 'kato-k/radiru.vim'
Plug 'keith/swift.vim'
Plug 'lambdalisue/fern-git-status.vim'
" Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern.vim'
Plug 'kato-k/fern-preview.vim'
Plug 'lambdalisue/gina.vim'
Plug 'lambdalisue/suda.vim'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-sandwich'
Plug 'mattn/emmet-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'tsuyoshicho/vim-efm-langserver-settings'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'rhysd/clever-f.vim'
Plug 'skanehira/translate.vim'
Plug 'thinca/vim-localrc'
Plug 'thinca/vim-quickrun'
Plug 'tokorom/vim-review'
Plug 'tyru/caw.vim'
Plug 'tyru/eskk.vim'
Plug 'vim-denops/denops.vim'
Plug 'vim-jp/vimdoc-ja'
Plug 'pangloss/vim-javascript'
Plug 'gelguy/wilder.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'editorconfig/editorconfig-vim'
Plug 'rhysd/vim-healthcheck'
Plug 'kat0h/dps-file.vim'
" Plug 'mattn/vim-treesitter'
" Plug 'mhinz/vim-sayonara'
call plug#end()
"}}}

" Options
" -----------------------------------------------------------------------------
" Mapping Table-------------------------------------------------------------{{{
"           モード  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
"    コマンド       +------+-----+-----+-----+-----+-----+------+------+
"    [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
"    n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
"    [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
"    i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
"    c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
"    v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
"    x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
"    s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
"    o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
"    t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
"    l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |
"}}}

" Display {{{
set ambiwidth=double
set number
" set signcolumn=yes
syntax enable
set termguicolors
set t_ZH=
set t_ZR=
set t_ut=
" set scrolloff=20
" set cursorline
"}}}
" Complete {{{
set completeopt+=menuone,menu,preview
set pumheight=12
"}}}
" Indent {{{
set expandtab
set shiftround
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=0
set autoindent
set tabstop=2
augroup VimrcIndent
  autocmd!
  autocmd FileType go setlocal noexpandtab
augroup END
"}}}
" Search {{{
set incsearch
set ignorecase
set smartcase
set hlsearch
nnoremap <expr> N 'nN'[v:searchforward]
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <Esc><Esc> <Cmd>nohlsearch<Cr>
"}}}
" CommandLine {{{
set wildmenu
" set wildmode=longest,list,full
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
"}}}
" Mouse {{{
set mouse=a
set ttymouse=sgr
"}}}
" Window {{{
set autoread
set backspace=indent,eol,start
set hidden
set noequalalways
"}}}
" Shortmess {{{
" Vimの開始時に挨拶メッセージを表示しない
set shortmess+=I
" ins-completion-menu関連のメッセージを表示しない
set shortmess+=c
" 検索時に検索件数メッセージを表示しない。例えば "[1/5]"
set shortmess-=S
"}}}
" Backup {{{
set noswapfile
set nobackup
set nowritebackup
"}}}
" Fold {{{
set fillchars=fold:\ 
set foldtext=getline(v:foldstart)
augroup VimrcFold
  autocmd!
  autocmd ColorScheme * highlight! Folded guifg='#9ba4bf' guibg='#282A36'
  " autocmd FileType * setlocal foldmethod=syntax
  " autocmd FileType vim setlocal foldmethod=marker
augroup END
"}}}

" Others {{{
set ttimeoutlen=10
set helplang=ja,en
augroup VimrcHelp
  autocmd!
  autocmd FileType help nnoremap <buffer><Return> <C-]>
  autocmd FileType help nnoremap <buffer><BS> <C-o>
augroup END
set whichwrap=b,s,h,l,<,>,[,]
cabbr w!! w !sudo tee > /dev/null %
" }}}
" QuickFix {{{
augroup VimrcQuickFix
  autocmd!
  autocmd FileType qf nnoremap <silent><buffer>q :quit<CR>
  autocmd QuickFixCmdPost *grep* cwindow
augroup END
"}}}
" Terminal {{{
augroup VimrcTerminal
  autocmd!
  autocmd WinLeave * if &buftype == "terminal" | silent! execute "normal! i" | endif
  autocmd TerminalOpen * if &buftype == "terminal" | silent! set nobuflisted | endif
augroup END
tnoremap <C-y> <c-n\><c-n>
"}}}
" Create a new directory when the directory does not exist {{{
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
"}}}
" Mapping {{{
let mapleader = "\<Space>"
" Emacs Like cursor move {{{
inoremap <silent><C-a> <Home>
inoremap <silent><C-e> <End>
"}}}
" Move between windows {{{
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l
nnoremap <silent> <C-q> <C-w>q
" }}}
" Useful mappings {{{
nnoremap <expr> 0 getline('.')[0 : col('.') - 2] =~# '^\s\+$' ? '0' : '^'
nnoremap <silent><leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:call popup_clear()<cr><c-l>
nnoremap <silent>j gj
nnoremap <silent>k gk
vnoremap v $h
inoremap <expr> j getline('.')[col('.') - 2] ==# 'j' ? "\<BS>\<ESC>" : 'j'
"}}}
"}}}
" FileType {{{
augroup VimrcFileType
  autocmd!
  autocmd FileType vue syntax sync fromstart
  autocmd BufEnter *.re setlocal ft=review
augroup END
"}}}
" User defined commands {{{
command! Dotfiles :cd ~/dotfiles
command! DirOpen :call job_start("open .")
command! -nargs=1 -complete=file Open :call system("open".." '<args>'")
"}}}
" Create undo point {{{
inoremap <silent><C-w> <C-g>u<C-w>
inoremap <silent><C-u> <C-g>u<C-u>
inoremap <silent><C-m> <C-g>u<C-m>
"}}}
" Change buffer {{{
nnoremap <silent> <leader>n :bn<CR>
nnoremap <silent> <leader>p :bp<CR>
"}}}
" get redirect url {{{
function! GetRedirectUrl(url) abort
  let r = system('curl -w "%{redirect_url}" -s -o /dev/null ' .. shellescape(a:url))
  if r == ""
    return a:url
  endif
  return r
endfunction
vnoremap r c<C-r>=GetRedirectUrl(@")<CR><esc>


"https://deno.land/x/denops_std/batch/mod.ts"
" }}}

" Plugin Options
" -----------------------------------------------------------------------------
" Vim-lsp {{{
if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  " setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
endfunction
augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1

imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

nnoremap <expr> <C-]> len(taglist(expand("<cword>")))?"<C-]>":":LspDefinition<CR>"
nnoremap <leader>F :LspDocumentFormat<CR>

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'allowlist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

function s:change_ts_ls() abort
  if finddir('node_modules', expand('%:p:h') . ';') ==# ''
    if exists('g:lsp_settings_filetype_typescript') &&
          \(g:lsp_settings_filetype_typescript->index('typescript-language-server') != -1)
      call timer_start(100, {-> (execute("LspStopServer typescript-language-server"))})
    endif
    let g:lsp_settings_filetype_typescript = ['deno']
  else
    if exists('g:lsp_settings_filetype_typescript') &&
          \(g:lsp_settings_filetype_typescript->index('deno') != -1)
      call timer_start(100, {-> (execute("LspStopServer deno"))})
    endif
    let g:lsp_settings_filetype_typescript = ['typescript-language-server']
  endif
endfunction

augroup VimrcLspFt
  autocmd!
  autocmd BufReadPre *.js,*.ts,*.jsx,*.tsx :call s:change_ts_ls()
augroup END
"}}}
" LightLine {{{
set laststatus=2
set noshowmode
function! L_eskk_get_mode() abort
  if (mode() == 'i') && eskk#is_enabled()
    return g:eskk#statusline_mode_strings[eskk#get_mode()]
  else
    return ''
  endif
endfunction

let g:lightline = {
\  'active': {
\    'left': [['mode', 'paste'], ['readonly', 'modified', 'filename', 'eskk'], ['radiru']],
\    'right': [['scroll'], ['fileencoding', 'filetype']],
\  },
\
\  'inactive': {
\    'left': [['filename']],
\    'right': [['filetype']],
\  },
\
\  'colorscheme': 'dracula',
\  'component_function': {
\    'radiru': 'radiru#playing_station',
\    'eskk': 'L_eskk_get_mode',
\    'scroll': 'L_scrollbar'
\  },
\  }

" }}}
" eskk {{{
if !filereadable(expand('~/.config/eskk/SKK-JISYO.L'))
  call mkdir('~/.config/eskk', 'p')
  call system('cd ~/.config/eskk/ && wget http://openlab.jp/skk/dic/SKK-JISYO.L.gz && gzip -d SKK-JISYO.L.gz')
endif
let g:eskk#directory = "~/.config/eskk"
let g:eskk#dictionary = { 'path': "~/.config/eskk/my_jisyo", 'sorted': 1, 'encoding': 'utf-8',}
let g:eskk#large_dictionary = {'path': "~/.config/eskk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp',}
"}}}
" translate {{{
nnoremap <leader>t :Translate<CR>
vnoremap <leader>t :Translate<CR>
"}}}
" clever-f {{{
map ; <Plug>(clever-f-repeat-forward)
map , <Plug>(clever-f-repeat-back)
" }}}
" fern {{{
let g:fern#disable_viewer_spinner = 1
nnoremap <leader>f <cmd>Fern . -drawer -toggle<CR>
function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent><expr> <buffer> <C-d> fern_preview#is_win_visible()?"<Plug>(fern-action-preview:scroll:down:half)":"<C-d>"
  nmap <silent><expr> <buffer> <C-u> fern_preview#is_win_visible()?"<Plug>(fern-action-preview:scroll:up:half)":"<C-u>"
endfunction
augroup VimrcFern
  autocmd!
  autocmd FileType fern setlocal nocursorline
  autocmd FileType fern setlocal nonumber
  autocmd FileType fern call s:fern_settings()
augroup END
"}}}
" Ignore Vim's standard pugin {{{
let g:loaded_2html_plugin      = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_matchparen        = 1
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
"}}}
" ColorScheme {{{
colorscheme dracula
" }}}
" Gina{{{
cabbrev git Gina
" }}}
" wilder.nvim {{{
call wilder#setup({
      \ 'modes': [':', '/', '?'],
      \ 'next_key': '<C-f>',
      \ 'previous_key': '<C-b>',
      \ 'accept_key': '<Tab>',
      \ })
call wilder#set_option('renderer', wilder#popupmenu_renderer({
      \ 'highlighter': wilder#basic_highlighter(),
      \ }))
" }}}
