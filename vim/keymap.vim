let mapleader = "\<Space>"

" <esc>の反応
set ttimeoutlen=10

" Undoポイントの設置
inoremap <silent><C-w> <C-g>u<C-w>
inoremap <silent><C-u> <C-g>u<C-u>
inoremap <silent><C-m> <C-g>u<C-m>

" 0の挙動を調節(借りもの)
nnoremap <expr> 0 getline('.')[0 : col('.') - 2] =~# '^\s\+$' ? '0' : '^'

" バッファの切り替え
nnoremap <silent> <leader>n :bn<CR>
nnoremap <silent> <leader>p :bp<CR>

" スムーズスクロール
let s:stop_time = 10
function! s:down(timer) abort
    execute "normal! 3\<C-e>3j"
endfunction
function! s:up(timer) abort
    execute "normal! 3\<C-y>3k"
endfunction
function! s:smooth_scroll(fn) abort " {{{
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
" }}}
nnoremap <silent> <C-u> <cmd>call <SID>smooth_scroll('up')<CR>
nnoremap <silent> <C-d> <cmd>call <SID>smooth_scroll('down')<CR>
vnoremap <silent> <C-u> <cmd>call <SID>smooth_scroll('up')<CR>
vnoremap <silent> <C-d> <cmd>call <SID>smooth_scroll('down')<CR>

" <C-p> <C-n> でも履歴を参照する
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
