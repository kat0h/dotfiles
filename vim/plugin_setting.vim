" Gina
" ==============================================================================
cabbrev git Gina

" clever-f
" ==============================================================================
map ; <Plug>(clever-f-repeat-forward)
map , <Plug>(clever-f-repeat-back)

" translate.vim
" ==============================================================================
nnoremap <leader>t :Translate<CR>
vnoremap <leader>t :Translate<CR>

" vimdoc-ja
" ==============================================================================
set helplang=ja,en
augroup VimrcHelp
  autocmd!
  autocmd FileType help nnoremap <buffer><Return> <C-]>
  autocmd FileType help nnoremap <buffer><BS> <C-o>
  autocmd FileType help nnoremap <buffer>q <C-w>q
augroup END

" lightline
" ==============================================================================
set laststatus=2
set noshowmode
function! LightlineSkkGetMode() abort
  let l:mode = skkeleton#mode()
  if l:mode == ''
    return 'Aa'
  elseif l:mode == 'hira'
    return 'あ'
  elseif l:mode == 'kata'
    return 'ア'
  endif
endfunction
let g:lightline = {
\  'active': {
\    'left': [['mode', 'paste'], ['readonly', 'modified', 'filename'], ['skk' ,'radiru']],
\    'right': [['scroll'], ['fileencoding', 'filetype']],
\  },
\
\  'inactive': {
\    'left': [['filename']],
\    'right': [['filetype']],
\  },
\  'component_function': {
\    'radiru': 'radiru#playing_station',
\    'skk': 'LightlineSkkGetMode',
\    'lfilename': 'LightlineFilename'
\  },
\}


" fern vim
" ==============================================================================
let g:fern#disable_viewer_spinner = 1
augroup VimrcFern
  autocmd!
  " autocmd FileType fern setlocal nocursorline
  autocmd FileType fern setlocal nonumber
  autocmd FileType fern call s:fern_settings()
  autocmd FileType fern nnoremap <buffer>CD <Plug>(fern-action-cd)
augroup END
function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent><expr> <buffer> <C-d> fern_preview#is_win_visible()?"<Plug>(fern-action-preview:scroll:down:half)":"<C-d>"
  nmap <silent><expr> <buffer> <C-u> fern_preview#is_win_visible()?"<Plug>(fern-action-preview:scroll:up:half)":"<C-u>"
endfunction
nnoremap <silent><leader>f :Fern . -drawer -toggle<CR>
let g:fern#renderer = "nerdfont"
let g:fern#renderer#nerdfont#padding = "  "
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
augroup END

" denops.vim
let g:denops#debug = 0
let g:denops#type_check = 0

" skkeleten
" ==============================================================================
if !filereadable(expand('~/.config/skk/SKK-JISYO.L'))
  call mkdir(expand('~/.config/skk'), 'p')
  call system('cd ~/.config/skk && wget http://openlab.jp/skk/dic/SKK-JISYO.L.gz && gzip -d SKK-JISYO.L.gz')
endif
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)
function! s:skkeleton_init() abort
  call skkeleton#config({
        \ "globalJisyo": expand("~/.config/skk/SKK-JISYO.L"),
        \})
endfunction
autocmd User skkeleton-initialize-pre call s:skkeleton_init()

" colorscheme
" ==============================================================================
colorscheme nightfly
let g:lightline['colorscheme'] = 'nightfly'

" ddc.vim
" ==============================================================================
call ddc#custom#patch_global({
      \ 'backspaceCompletion': v:true,
      \ })
call ddc#custom#patch_global('sources', [
      \ 'vim-lsp',
      \ 'file',
      \ 'around',
      \ ])
call ddc#custom#patch_global('sourceOptions', {
  \   '_': {
  \     'matchers': ['matcher_fuzzy'],
  \     'sorters': ['sorter_fuzzy'],
  \     'ignoreCase': v:true,
  \   }
  \ })
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'forceCompletionPattern': '\.',
      \ },
      \ })
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'minAutoCompleteLength': 1,
      \ },
      \ })
call ddc#custom#patch_global('sourceOptions', {
      \ 'vim-lsp': {
      \   'matchers': ['matcher_head'],
      \   'mark': ' ',
      \   'dup': v:true,
      \ },
      \ })
call ddc#custom#patch_global('sourceOptions', {
      \ 'file': {
      \   'mark': ' ',
      \   'isVolatile': v:true,
      \   'minAutoCompleteLength': 1000,
      \   'forceCompletionPattern': '\S/\S*'
      \ },
      \})
call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': ' '},
      \ })
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'
" inoremap <expr><cr> pumvisible() ? '<c-y>' : '<cr>'
call ddc#enable()

" LSP
" ==============================================================================
function s:change_ts_ls() abort
  if finddir('node_modules', expand('%:p:h') . ';') ==# ''
    if exists('g:lsp_settings_filetype_typescript') &&
          \(g:lsp_settings_filetype_typescript->index('typescript-language-server') != -1)
      call timerstart(100, {-> (execute("LspStopServer typescript-language-server"))})
    endif
    let g:lsp_settings_filetype_typescript = ['deno']
  else
    if exists('g:lsp_settings_filetype_typescript') &&
          \(g:lsp_settings_filetype_typescript->index('deno') != -1)
      call timerstart(100, {-> (execute("LspStopServer deno"))})
    endif
    let g:lsp_settings_filetype_typescript = ['typescript-language-server']
  endif
endfunction
augroup VimrcLspFt
  autocmd!
  autocmd BufReadPre *.js,*.ts,*.jsx,*.tsx :call s:change_ts_ls()
augroup END
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
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

" ddu.vim
" ==============================================================================
" let s:ddu_patch_global = {}
" let s:ddu_patch_global.uiParams = {}
" let s:ddu_patch_global.sourceOptions = {}
" let s:ddu_patch_global.filterParams = {}
" let s:ddu_patch_global.kindOptions = {}
" 
" let s:ddu_patch_global.ui = 'ff'
" let s:ddu_patch_global.uiParams.ff = {
"  \'startFilter': v:true,
"  \'prompt': '> ',
"  \'split': v:false ? 'floating' : 'horizontal',
"\}
" 
" let s:ddu_patch_global.sources = [
"  \{'name': 'file_rec'},
"  \{'name': 'action'},
"  \{'name': 'source'},
"  \{'name': 'help'},
"\]
" let s:ddu_patch_global.sourceOptions._ = {
"  \'matchers': ['matcher_fuse'],
"\}
" 
" let s:ddu_patch_global.filterParams.matcher_fuse = {
"  \'threshold': 0.8,
"  \'highlightMatched': 'Title',
"\}
" 
" let s:ddu_patch_global.kindOptions.file = {
"  \'defaultAction': 'open',
"\}
" let s:ddu_patch_global.kindOptions.action = {
"  \'defaultAction': 'do',
"\}
" 
" 
" call ddu#custom#patch_global(s:ddu_patch_global)
" 
" "ddu-key-setting
" autocmd FileType ddu-ff call s:ddu_my_settings()
" function! s:ddu_my_settings() abort
"   nnoremap <buffer><silent> <CR>
"        \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
"   nnoremap <buffer><silent> a
"        \ <Cmd>call ddu#ui#ff#do_action('chooseAction')<CR>
"   nnoremap <buffer><silent> p
"        \ <Cmd>call ddu#ui#ff#do_action('preview')<CR>
"   nnoremap <buffer><silent> i
"        \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
"   nnoremap <buffer><silent> q
"        \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
" endfunction
" 
" autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
" function! s:ddu_filter_my_settings() abort
"   inoremap <buffer><silent> <CR>
"  \ <Esc><Cmd>close<CR>
"   inoremap <buffer><silent> <Esc>
"  \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
"   nnoremap <buffer><silent> q
"  \ <Cmd>close<CR>
" endfunction
" 
" "ddu keymapping.
" nnoremap <SID>[ug] <Nop>
" nmap <leader><leader> <SID>[ug]
" 
" nnoremap <silent> <SID>[ug]f :<C-u>Ddu file_rec<CR>
" cabbrev d Ddu

" CtrlP
nnoremap <silent><leader>p :CtrlP . -drawer -toggle<CR>

" Ripgrep
command! -nargs=* -complete=file Rg :call ripgrep#search(<q-args>)
cabbrev rg Rg
