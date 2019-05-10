if g:dein#_cache_version !=# 100 || g:dein#_init_runtimepath !=# '/Users/katokota/.vim,/usr/local/share/vim/vimfiles,/usr/local/share/vim/vim81,/usr/local/share/vim/vimfiles/after,/Users/katokota/.vim/after,/Users/katokota/.vim/./dein/repos/github.com/Shougo/dein.vim' | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/Users/katokota/.vimrc', '/Users/katokota/.vim/dein/rc//dein.toml', '/Users/katokota/.vim/dein/rc//dein_lazy.toml'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/Users/katokota/.vim/./dein'
let g:dein#_runtime_path = '/Users/katokota/.vim/./dein/.cache/.vimrc/.dein'
let g:dein#_cache_path = '/Users/katokota/.vim/./dein/.cache/.vimrc'
let &runtimepath = '/Users/katokota/.vim,/usr/local/share/vim/vimfiles,/Users/katokota/.vim/./dein/repos/github.com/Shougo/dein.vim,/Users/katokota/.vim/./dein/.cache/.vimrc/.dein,/usr/local/share/vim/vim81,/usr/local/share/vim/vim81/pack/dist/opt/matchit,/Users/katokota/.vim/./dein/.cache/.vimrc/.dein/after,/usr/local/share/vim/vimfiles/after,/Users/katokota/.vim/after,/usr/local/opt/fzf'
filetype off
let g:loaded_matchparen = 1
source $VIMRUNTIME/macros/matchit.vim
set laststatus=2
set noshowmode
let g:lightline = { 'colorscheme': 'seoul256', }
set rtp+=/usr/local/opt/fzf
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'ag --hidden --ignore .git -g ""'}), <bang>0)
command! -bang -nargs=* Ag call fzf#vim#grep(   'ag --column --color --hidden --ignore .git '.shellescape(<q-args>), 0,   <bang>0 ? fzf#vim#with_preview('up:60%')           : fzf#vim#with_preview('right:50%', '?'),   <bang>0)
nmap \b :Buffers<Enter>
nmap \f :Files<Enter>
nmap \t :Tags<Enter>
let g:ale_sign_error   = '!}'
let g:ale_sign_warning = '?}'
let g:indent_guides_guide_size = 1
