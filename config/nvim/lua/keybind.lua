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
