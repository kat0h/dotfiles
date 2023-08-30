local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'nvim-lua/plenary.nvim',
  },
	{
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd[[colorscheme tokyonight]]
		end,
	},
	{
		'williamboman/mason-lspconfig.nvim',
		dependencies = {
			'williamboman/mason.nvim',
			'neovim/nvim-lspconfig',
			'glepnir/lspsaga.nvim',
			'j-hui/fidget.nvim',
			'folke/neodev.nvim'
		}
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/vim-vsnip',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-cmdline',
		},
	},
	{
		'kyazdani42/nvim-tree.lua',
		keys = {
			{ "<Space>f", "<Cmd>NvimTreeToggle<CR>", mode = "n" },
		},
		config = function()
			require("nvim-tree").setup({
			  sort_by = "case_sensitive",
			  view = {
			    adaptive_size = true,
			  },
			  renderer = {
			    group_empty = true,
			  },
			  filters = {
			    dotfiles = true,
			  },
			})
			vim.cmd[[
			set splitright
			]]
		end
	},
	{
		'kat0h/bufpreview.vim',
		lazy = false,
		build = 'deno task prepare'
	},
	{
		'vim-denops/denops.vim',
		lazy = false,
	},
	{
		'vim-jp/vimdoc-ja',
	},
	{
		'kyazdani42/nvim-web-devicons',
	},
	{
		'windwp/nvim-autopairs',
		config = function()
			require("nvim-autopairs").setup {}
		end
	},
	{
		'nvim-telescope/telescope.nvim',
		keys = {
			{ "<Space>t", "<Cmd>Telescope<CR>", mode = "n" },
		},
	}

})

--   -- filer
--   use 
-- 
--   -- Display
--   use {'kat0h/bufpreview.vim', run = 'deno task prepare' }
--   use 'simrat39/symbols-outline.nvim'
--   use 'lewis6991/gitsigns.nvim'
-- 
--   -- scrollbar
--   use 'petertriho/nvim-scrollbar'
--   use 'kevinhwang91/nvim-hlslens'
-- 
-- 
--   -- Statusline
--   use 'nvim-lualine/lualine.nvim'
--   use -- 
--   -- Keybindings
--   use 'delphinus/emcl.nvim'
--   use --   use 'monaqa/dial.nvim'
--   use 'machakann/vim-sandwich'
--   use 'numToStr/Comment.nvim'
--   use 'vim-skk/skkeleton'
--   use 'delphinus/skkeleton_indicator.nvim'
-- 
--   -- Git
--   use 'TimUntersberger/neogit'
-- 
--   -- Telescope
--   use -- 
--   -- library
--   use 
--   use -- 
--   -- Vimdoc ja
--   use -- end)
-- 
-- 
-- -- set formatoptions-=c formatoptions-=r formatoptions-=o
-- 
require('base')
require('highlights')
-- require('statusline')
-- require('display')
-- require('filer')
-- require('lsp')
-- require('telescopes')
-- vim.cmd 'source ~/.vim/keymap.vim'
