require("emcl").setup {}
require("nvim-autopairs").setup {}

-- dial.nvim
vim.cmd [[
  nmap  <C-a>  <Plug>(dial-increment)
  nmap  <C-x>  <Plug>(dial-decrement)
  vmap  <C-a>  <Plug>(dial-increment)
  vmap  <C-x>  <Plug>(dial-decrement)
  vmap g<C-a> g<Plug>(dial-increment)
  vmap g<C-x> g<Plug>(dial-decrement)
]]

require('Comment').setup {}


vim.cmd [[
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
]]
