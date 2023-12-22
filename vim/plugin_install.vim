call jetpack#begin(g:plugin_cache_dir)
Jetpack 'tani/vim-jetpack'
Jetpack 'kat0h/radiru.vim'
Jetpack 'lambdalisue/gina.vim'
Jetpack 'thinca/vim-quickrun'
Jetpack 'mhinz/vim-sayonara'
Jetpack 'rhysd/clever-f.vim'
Jetpack 'skanehira/translate.vim'
Jetpack 'bronson/vim-trailing-whitespace'
Jetpack 'tyru/open-browser.vim'
Jetpack 'vim-jp/vimdoc-ja'
Jetpack 'leafgarland/typescript-vim'
Jetpack 'itchyny/lightline.vim'
Jetpack 'tyru/caw.vim'
Jetpack 'machakann/vim-sandwich'
Jetpack 'pangloss/vim-javascript'
Jetpack 'cespare/vim-toml'
Jetpack 'lambdalisue/fern.vim'
" Jetpack 'mattn/vim-lsp-settings'
Jetpack 'lambdalisue/fern-renderer-nerdfont.vim'
Jetpack 'lambdalisue/nerdfont.vim'
Jetpack 'lambdalisue/glyph-palette.vim'
Jetpack 'vim-denops/denops.vim'
Jetpack 'vim-skk/skkeleton'
Jetpack 'sainnhe/everforest'
Jetpack 'rakr/vim-one'
Jetpack 'bluz71/vim-nightfly-guicolors'
" Jetpack 'Shougo/ddc.vim'
" Jetpack 'shun/ddc-vim-lsp'
" Jetpack 'Shougo/ddc-around'
" Jetpack 'Shougo/ddc-sorter_rank'
" Jetpack 'Shougo/ddc-matcher_head'
" Jetpack 'LumaKernel/ddc-file'
" Jetpack 'tani/ddc-fuzzy'
" Jetpack 'prabirshrestha/vim-lsp'
" Jetpack 'kat0h/vim-lsp-settings'
Jetpack 'hrsh7th/vim-vsnip'
Jetpack 'hrsh7th/vim-vsnip-integ'
" Jetpack 'Shougo/ddu.vim'
Jetpack 'vim-denops/denops.vim'
Jetpack 'ctrlpvim/ctrlp.vim'
Jetpack 'thinca/vim-prettyprint'
Jetpack 'kyoh86/vim-ripgrep'
Jetpack 'tani/glance-vim'
Jetpack 'kat0h/bufpreview.vim'
Jetpack 'neoclide/coc.nvim', {'branch': 'release'}
call jetpack#end()

for name in jetpack#names()
  if !jetpack#tap(name)
    call jetpack#sync()
    quitall!
  endif
endfor
