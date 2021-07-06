" _    _ _____ _______  ______ _______
"   \  /    |   |  |  | |_____/ |
"    \/   __|__ |  |  | |    \_ |_____"

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
Plug 'haya14busa/is.vim'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-parenmatch'
Plug 'itchyny/vim-winfix'
Plug 'kato-k/cica-support.vim'
Plug 'kato-k/hiroyuki.vim'
Plug 'kato-k/radiru.vim'
Plug 'keith/swift.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/gina.vim'
Plug 'lambdalisue/suda.vim'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-sandwich'
Plug 'mattn/emmet-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim'
Plug 'rhysd/clever-f.vim'
Plug 'skanehira/translate.vim'
Plug 'thinca/vim-localrc'
Plug 'thinca/vim-quickrun'
Plug 'tokorom/vim-review'
Plug 'tyru/caw.vim'
Plug 'tyru/eskk.vim'
Plug 'vim-denops/denops.vim'
Plug 'vim-jp/vimdoc-ja'
Plug 'vimwiki/vimwiki'
Plug 'yuki-yano/fern-preview.vim'
Plug 'lambdalisue/vim-gista'
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
set signcolumn=yes
set termguicolors
" set colorcolumn=80
set t_ZH=
set t_ZR=
set scrolloff=20
set cursorline
syntax enable
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
"}}}
" CommandLine {{{
set wildmenu
set wildmode=longest,list,full
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
  autocmd FileType * setlocal foldmethod=syntax
  autocmd FileType vim setlocal foldmethod=marker
augroup END
"}}}

" Others {{{
set helplang=ja,en
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
" }}}
" Useful mappings {{{
nnoremap <expr> 0 getline('.')[0 : col('.') - 2] =~# '^\s\+$' ? '0' : '^'
nnoremap <silent><leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:call popup_clear()<cr><c-l>
nnoremap <silent>j gj
nnoremap <silent>k gk
vnoremap v $h
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
command! Open :call job_start("open")
function! s:cmd_open() abort

endfunction
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

" Plugin Options
" -----------------------------------------------------------------------------
" coc {{{
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-@> coc#refresh()
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation() 
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Formatting selected code.
xmap <leader>cf  <Plug>(coc-format-selected)
nmap <leader>cf  <Plug>(coc-format-selected)
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
" Remap <C-f> and <C-b> for scroll float windows/popups.
" \はいらない?
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.

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
          \  'component_function': {
            \    'radiru': 'radiru#playing_station',
            \    'eskk': 'L_eskk_get_mode',
            \    'scroll': 'L_scrollbar'
            \  },
            \
            \  'colorscheme': 'dracula',
            \  }
            "\  'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
            "\  'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },

" }}}
" eskk {{{
if !filereadable(expand('~/.config/eskk/SKK-JISYO.L'))
  call mkdir('~/.config/eskk', 'p')
  call system('cd ~/.config/eskk/ && wget http://openlab.jp/skk/dic/SKK-JISYO.L.gz && gzip -d SKK-JISYO.L.gz')
endif
let g:eskk#directory = "~/.config/eskk"
let g:eskk#dictionary = { 'path': "~/.config/eskk/my_jisyo", 'sorted': 1, 'encoding': 'utf-8',}
let g:eskk#large_dictionary = {'path': "~/.config/eskk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp',}
let g:eskk#enable_completion = 0
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
augroup VimrcFern
  autocmd!
  autocmd FileType fern setlocal nocursorline
  autocmd FileType fern nmap <silent> <buffer> p <Plug>(fern-action-preview:toggle)
  autocmd FileType fern nmap <silent> <buffer> P <Plug>(fern-action-preview:auto:toggle)
  autocmd FileType fern nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  autocmd FileType fern nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
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
" Gista{{{
let g:gista#client#default_username = "kato-k"
" }}}
" Gina{{{
cabbrev git Gina
" }}}
