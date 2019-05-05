if g:dein#_cache_version !=# 100 || g:dein#_init_runtimepath !=# '/Users/katokota/.vim,/usr/local/share/vim/vimfiles,/usr/local/share/vim/vim81,/usr/local/share/vim/vimfiles/after,/Users/katokota/.vim/after,/Users/katokota/.vim/./dein/repos/github.com/Shougo/dein.vim' | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/Users/katokota/.vimrc'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/Users/katokota/.vim/./dein'
let g:dein#_runtime_path = '/Users/katokota/.vim/./dein/.cache/.vimrc/.dein'
let g:dein#_cache_path = '/Users/katokota/.vim/./dein/.cache/.vimrc'
let &runtimepath = '/Users/katokota/.vim,/usr/local/share/vim/vimfiles,/Users/katokota/.vim/./dein/repos/github.com/Shougo/dein.vim,/Users/katokota/.vim/./dein/.cache/.vimrc/.dein,/usr/local/share/vim/vim81,/Users/katokota/.vim/./dein/.cache/.vimrc/.dein/after,/usr/local/share/vim/vimfiles/after,/Users/katokota/.vim/after'
filetype off
