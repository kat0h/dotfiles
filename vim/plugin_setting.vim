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
" call ddc#custom#patch_global({
"       \ 'backspaceCompletion': v:true,
"       \ })
" call ddc#custom#patch_global('sources', [
"       \ 'vim-lsp',
"       \ 'file',
"       \ 'around',
"       \ ])
" call ddc#custom#patch_global('sourceOptions', {
"   \   '_': {
"   \     'matchers': ['matcher_fuzzy'],
"   \     'sorters': ['sorter_fuzzy'],
"   \     'ignoreCase': v:true,
"   \   }
"   \ })
" call ddc#custom#patch_global('sourceOptions', {
"       \ '_': {
"       \   'forceCompletionPattern': '\.',
"       \ },
"       \ })
" call ddc#custom#patch_global('sourceOptions', {
"       \ '_': {
"       \   'minAutoCompleteLength': 1,
"       \ },
"       \ })
" call ddc#custom#patch_global('sourceOptions', {
"       \ 'vim-lsp': {
"       \   'matchers': ['matcher_head'],
"       \   'mark': ' ',
"       \   'dup': v:true,
"       \ },
"       \ })
" call ddc#custom#patch_global('sourceOptions', {
"       \ 'file': {
"       \   'mark': ' ',
"       \   'isVolatile': v:true,
"       \   'minAutoCompleteLength': 1000,
"       \   'forceCompletionPattern': '\S/\S*'
"       \ },
"       \})
" call ddc#custom#patch_global('sourceOptions', {
"       \ 'around': {'mark': ' '},
"       \ })
" inoremap <silent><expr> <TAB>
" \ pumvisible() ? '<C-n>' :
" \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
" \ '<TAB>' : ddc#map#manual_complete()
" inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'
" " inoremap <expr><cr> pumvisible() ? '<c-y>' : '<cr>'
" call ddc#enable()

" LSP
" ==============================================================================
" function s:change_ts_ls() abort
"   if finddir('node_modules', expand('%:p:h') . ';') ==# ''
"     if exists('g:lsp_settings_filetype_typescript') &&
"           \(g:lsp_settings_filetype_typescript->index('typescript-language-server') != -1)
"       call timerstart(100, {-> (execute("LspStopServer typescript-language-server"))})
"     endif
"     let g:lsp_settings_filetype_typescript = ['deno']
"   else
"     if exists('g:lsp_settings_filetype_typescript') &&
"           \(g:lsp_settings_filetype_typescript->index('deno') != -1)
"       call timerstart(100, {-> (execute("LspStopServer deno"))})
"     endif
"     let g:lsp_settings_filetype_typescript = ['typescript-language-server']
"   endif
" endfunction
" augroup VimrcLspFt
"   autocmd!
"   autocmd BufReadPre *.js,*.ts,*.jsx,*.tsx :call s:change_ts_ls()
" augroup END
" function! s:on_lsp_buffer_enabled() abort
"   setlocal omnifunc=lsp#complete
"   nmap <buffer> gd <plug>(lsp-definition)
"   nmap <buffer> <f2> <plug>(lsp-rename)
" endfunction
" augroup lsp_install
"   au!
"   autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
" augroup END
" command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')
" let g:lsp_diagnostics_enabled = 1
" let g:lsp_diagnostics_echo_cursor = 1
" let g:asyncomplete_auto_popup = 1
" let g:asyncomplete_popup_delay = 200
" let g:lsp_text_edit_enabled = 1

" CtrlP
nnoremap <silent><leader>p :CtrlP . -drawer -toggle<CR>

" Ripgrep
command! -nargs=* -complete=file Rg :call ripgrep#search(<q-args>)
cabbrev rg Rg

" Glance
let g:glance#stylesheet = '@import url("https://cdn.jsdelivr.net/npm/water.css@2/out/water.css");'
let g:glance#markdown_breaks = v:true

" CoC
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>F  <Plug>(coc-format-selected)
nmap <leader>F  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
