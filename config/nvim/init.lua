-- install vim-jetpack if it isn't exist

local fn = vim.fn
local jetpackfile = fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackurl = 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
if fn.filereadable(jetpackfile) == 0 then
  fn.system('curl -fsSLo ' .. jetpackfile .. ' --create-dirs ' .. jetpackurl)
end

-- Load vim-jetpack
vim.cmd('packadd vim-jetpack')

require('jetpack.packer').startup(function (use)
  use { 'tani/vim-jetpack', opt = 1 } -- bootstrap vim-jetpack

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'glepnir/lspsaga.nvim'
  use 'folke/neodev.nvim'
  use 'j-hui/fidget.nvim'

  -- nvim-cmp
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-cmdline'

  -- Terminal
  use 'voldikss/vim-floaterm'

  -- filer
  use 'kyazdani42/nvim-tree.lua'

  -- Display
  use 'folke/tokyonight.nvim'
  use 'tamton-aquib/zone.nvim'
  use {'kat0h/bufpreview.vim', run = 'deno task prepare' }
  use 'simrat39/symbols-outline.nvim'
  use 'lewis6991/gitsigns.nvim'

  -- scrollbar
  use 'petertriho/nvim-scrollbar'
  use 'kevinhwang91/nvim-hlslens'


  -- Statusline
  use 'nvim-lualine/lualine.nvim'
  use 'kyazdani42/nvim-web-devicons'

  -- Keybindings
  use 'delphinus/emcl.nvim'
  use 'windwp/nvim-autopairs'
  use 'monaqa/dial.nvim'
  use 'machakann/vim-sandwich'
  use 'numToStr/Comment.nvim'
  use 'vim-skk/skkeleton'
  use 'delphinus/skkeleton_indicator.nvim'

  -- Git
  use 'TimUntersberger/neogit'

  -- Telescope
  use 'nvim-telescope/telescope.nvim'

  -- library
  use 'nvim-lua/plenary.nvim'
  use 'vim-denops/denops.vim'
  use 'vim-denops/denops.vim'

  -- Vimdoc ja
  use 'vim-jp/vimdoc-ja'
  use 'kat0h/bufpreview.vim'
end)


-- set formatoptions-=c formatoptions-=r formatoptions-=o

require('base')
require('highlights')
require('keybind')
require('statusline')
require('display')
require('filer')
require('lsp')
require('telescopes')
vim.cmd 'source ~/.vim/keymap.vim'
