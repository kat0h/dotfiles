scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8
set ambiwidth=double
set nobomb
set number
set completeopt+=menuone,menu,preview
set pumheight=12
set tabstop=2
set shiftwidth=2
set softtabstop=0
set expandtab
set smarttab
set smartindent
set shiftround
set incsearch
set ignorecase
set smartcase
set hlsearch
set wildmenu
set wildmode=longest,list,full
set termguicolors
set t_ZH=
set t_ZR=
set mouse=a
set ttymouse=sgr
set shortmess+=I
set hidden
set nobackup
set noswapfile
set nowritebackup
set autoread
set colorcolumn=80
set whichwrap=b,s,h,l,<,>,[,]
set backspace=indent,eol,start
set iskeyword+=-
set autoindent
set noequalalways
set shortmess-=S
set foldmethod=indent
set shortmess+=c
set signcolumn=number


" Install Plugins -------------------------------------------------------------

let s:plugCache = expand("~/.cache/plug") "{{{
if has('vim_starting')
  if !isdirectory(s:plugCache)
    call mkdir(s:plugCache, "p")
    call system("curl -fLo "
          \.. shellescape(s:plugCache .. "/plug.vim")
          \.. " https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
  endif
  execute ":source " ..  s:plugCache .. "/plug.vim"
endif "}}}
call plug#begin(s:plugCache) "{{{
Plug 'cespare/vim-toml'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dracula/vim'
Plug 'haya14busa/dein-command.vim'
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
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/gina.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'liuchengxu/vista.vim'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-sandwich'
Plug 'mattn/ctrlp-matchfuzzy'
Plug 'mattn/emmet-vim'
Plug 'mattn/vim-lexiv'
Plug 'mbbill/undotree'
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
call plug#end() "}}}



cabbr w!! w !sudo tee > /dev/null %
syntax enable

autocmd FileType qf nnoremap <silent><buffer>q :quit<CR>
autocmd QuickFixCmdPost *grep* cwindow
autocmd WinLeave * if &buftype == "terminal" | silent! execute "normal! i" | endif
autocmd TerminalOpen * if &buftype == "terminal" | silent! set nobuflisted | endif
tnoremap <C-y> <c-n\><c-n>
autocmd FileType * setlocal foldmethod=syntax
autocmd FileType vim setlocal foldmethod=marker
augroup vimrc-auto-mkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
augroup END
autocmd FileType vue syntax sync fromstart
autocmd BufNewFile,BufRead *.toml setf toml


command! OpenDot :cd ~/dotfiles
command! DirOpen :call job_start("open .")

function! s:auto_mkdir(dir, force)
if !isdirectory(a:dir) && (a:force ||
\    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
endif
endfunction
let mapleader = "\<Space>"

inoremap <silent><C-w> <C-g>u<C-w>
inoremap <silent><C-u> <C-g>u<C-u>
inoremap <silent><C-m> <C-g>u<C-m>
nnoremap <expr> 0 getline('.')[0 : col('.') - 2] =~# '^\s\+$' ? '0' : '^'
nnoremap <silent> <leader>n :bn<CR>
nnoremap <silent> <leader>p :bp<CR>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
inoremap <silent><C-a> <Home>
inoremap <silent><C-e> <End>
nnoremap <silent>j gj
nnoremap <silent>k gk
nnoremap <silent><leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:call popup_clear()<cr><c-l>
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-@> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

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
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
set helplang=ja,en
let g:loaded_matchparen = 1
let g:rainbow_active = 0
set laststatus=2
set noshowmode
function L_eskk_get_mode()
    if (mode() == 'i') && eskk#is_enabled()
        return g:eskk#statusline_mode_strings[eskk#get_mode()]
    else
        return ''
    endif
endfunction
let g:lightline = {
\   'active': {
\     'left': [['mode', 'paste'], ['readonly', 'filename', 'eskk', 'modified'], ['radiru']],
\     'right': [['lineinfo'], ['percent'], ['suez', 'fileencoding', 'filetype']]
\   },
\   'component_function': {
\     'radiru': 'radiru#playing_station',
\     'eskk': 'L_eskk_get_mode',
\     'suez': 'suez#status',
\   },
\   'colorscheme': 'dracula',
\ }
nnoremap <leader>u :<C-u>UndotreeToggle<cr>
nnoremap <silent> <Leader>o :<C-u>Vista!!<CR>
if !filereadable(expand('~/.config/eskk/jisyo'))
    call mkdir('~/.config/eskk', 'p')
    call system('cd ~/.config/eskk/ && wget http://openlab.jp/skk/dic/SKK-JISYO.L.gz && gzip -d SKK-JISYO.L.gz')
endif
let g:eskk#directory = "~/.config/eskk"
let g:eskk#dictionary = { 'path': "~/.config/eskk/my_jisyo", 'sorted': 1, 'encoding': 'utf-8',}
let g:eskk#large_dictionary = {'path': "~/.config/eskk/SKK-JISYO.L", 'sorted': 1, 'encoding': 'utf-8',}
let g:eskk#enable_completion = 0
let g:ctrlp_match_func = {'match': 'ctrlp_matchfuzzy#matcher'}
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
nnoremap <leader>t :Translate<CR>
vnoremap <leader>t :Translate<CR>
map ; <Plug>(clever-f-repeat-forward)
map , <Plug>(clever-f-repeat-back)
autocmd BufEnter *.re setlocal ft=review
colorscheme dracula
nnoremap <leader>f <cmd>Fern . -drawer -toggle<CR>
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
