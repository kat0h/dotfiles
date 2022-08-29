call jetpack#begin(g:plugin_cache_dir)

" Lua library
Jetpack 'nvim-lua/plenary.nvim'

" Colorscheme
Jetpack 'folke/tokyonight.nvim'

" Statusline
Jetpack 'nvim-lualine/lualine.nvim'
Jetpack 'kyazdani42/nvim-web-devicons'

" Emacs keybindings
Jetpack 'delphinus/emcl.nvim'

" scrollbar
Jetpack 'petertriho/nvim-scrollbar'
Jetpack 'kevinhwang91/nvim-hlslens'

" filer
Jetpack 'kyazdani42/nvim-tree.lua'

" Tree sitter
Jetpack 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}

" Joke
Jetpack 'tamton-aquib/zone.nvim'

" Git
Jetpack 'TimUntersberger/neogit'

call jetpack#end()

for name in jetpack#names()
  if !jetpack#tap(name)
    call jetpack#sync()
    quitall!
  endif
endfor
