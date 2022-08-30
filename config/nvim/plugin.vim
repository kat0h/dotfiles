call jetpack#begin(g:plugin_cache_dir)

" LSP
Jetpack 'neovim/nvim-lspconfig'
Jetpack 'williamboman/mason.nvim'
Jetpack 'williamboman/mason-lspconfig.nvim'

" nvim-cmp
Jetpack 'hrsh7th/nvim-cmp'
Jetpack 'hrsh7th/cmp-nvim-lsp'
Jetpack 'hrsh7th/vim-vsnip'
Jetpack 'hrsh7th/cmp-path'
Jetpack 'hrsh7th/cmp-buffer'
Jetpack 'hrsh7th/cmp-cmdline'

" Terminal
Jetpack 'voldikss/vim-floaterm'

" filer
Jetpack 'kyazdani42/nvim-tree.lua'

" Display
Jetpack 'folke/tokyonight.nvim'
Jetpack 'tamton-aquib/zone.nvim'
Jetpack 'lukas-reineke/indent-blankline.nvim'

" scrollbar
Jetpack 'petertriho/nvim-scrollbar'
Jetpack 'kevinhwang91/nvim-hlslens'


" Statusline
Jetpack 'nvim-lualine/lualine.nvim'
Jetpack 'kyazdani42/nvim-web-devicons'

" Keybindings
Jetpack 'delphinus/emcl.nvim'
Jetpack 'windwp/nvim-autopairs'
Jetpack 'monaqa/dial.nvim'

" Tree sitter
Jetpack 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}

" Git
Jetpack 'TimUntersberger/neogit'

" Lua library
Jetpack 'nvim-lua/plenary.nvim'

call jetpack#end()

for name in jetpack#names()
  if !jetpack#tap(name)
    call jetpack#sync()
    quitall!
  endif
endfor
