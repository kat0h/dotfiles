" ディレクトリがないとき自動で作る
function! s:auto_mkdir(dir, force)
if !isdirectory(a:dir) && (a:force ||
\    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
endif
endfunction
augroup vimrc-auto-mkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
augroup END
