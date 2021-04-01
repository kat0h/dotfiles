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

" <C-p> <C-n> でも履歴を参照する
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Emacs風の移動
inoremap <C-a> <Home>
inoremap <C-e> <End>

nnoremap j gj
nnoremap k gk

nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

nnoremap <silent><leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:call popup_clear()<cr><c-l>

xnoremap <  <gv
xnoremap >  >gv

nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

