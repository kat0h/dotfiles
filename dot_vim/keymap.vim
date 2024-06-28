let mapleader = "\<Space>"

nnoremap <expr> N 'nN'[v:searchforward]
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <Esc><Esc> :nohlsearch<Cr>

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
" inoremap <C-n> <Down>
" inoremap <C-p> <Up>

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
