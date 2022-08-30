vim.cmd 'source ~/.vim/jetpack_install.vim'
vim.cmd 'source ~/.config/nvim/plugin.vim'

require('base')
require('highlights')
require('keybind')
require('statusline')
require('display')
require('filer')
require('lsp')
vim.cmd 'source ~/.vim/keymap.vim'
