if has('nvim')
  let s:cache_dir = expand('~/.cache/jetpack/nvim')
else
  let s:cache_dir = expand('~/.cache/jetpack/vim')
endif
let s:manage_cache_dir = s:cache_dir .. "/m"
let g:plugin_cache_dir = s:cache_dir .. "/p"

let s:jetpackfile = s:manage_cache_dir .. "/autoload/jetpack.vim"
let s:jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if !filereadable(s:jetpackfile)
  call system(printf('curl -fsSLo %s --create-dirs %s', s:jetpackfile, s:jetpackurl))
  quit
endif
execute("set runtimepath^=" .. s:manage_cache_dir)
