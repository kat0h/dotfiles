"      |              o
" ,---.|    .   .,---..,---.
" |   ||    |   ||   |||   |
" |---'`---'`---'`---|``   '
" |              `---'

let s:rc_dir = expand("~/.vim/deinrc/")
let s:loads = [
            \ #{path: "color.toml", lazy: v:false},
            \ #{path: "ferm.toml", lazy: v:false},
            \ #{path: "general.toml", lazy: v:false},
            \ #{path: "lsp.toml", lazy: v:false},
            \ #{path: "dein_lazy.toml", lazy: v:true},
            \]

" Install dein.vim if there is no dein.vim
if has('vim_starting')
    let s:dein_cache_home = empty($XDG_CACHE_HOME) ? expand("~/.cache") : $XDG_CACHE_HOME
    let s:dein_dir = s:dein_cache_home .. '/vim/dein'
    let s:dein_repo_dir = s:dein_dir .. 'repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' .. shellescape(s:dein_repo_dir))
    endif
    let &runtimepath = &runtimepath .. ',' .. s:dein_repo_dir
endif

" Install plugins
if &compatible
  set nocompatible
endif
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#add(s:dein_repo_dir)
    for s:toml in s:loads
        call dein#load_toml(s:rc_dir .. s:toml['path'], {'lazy': s:toml['lazy']})
    endfor
    call dein#end()
    call dein#save_state()
endif
filetype plugin indent on
syntax enable
if dein#check_install()
    call dein#install()
endif

if has('vim_starting')
    let tokenpath = expand('$HOME/.config/github_tokens/dein.token')
    if filereadable(tokenpath)
    let token = readfile(tokenpath)
    let g:dein#install_github_api_token = token[0]
    endif
endif
