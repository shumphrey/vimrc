if exists("current_compiler")
    finish
endif
let current_compiler = "eslint"

if exists(":CompilerSet") != 2 
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet errorformat=
    \%-G%.%#File\ ignored\ by\ default%.%#,
    \%f:\ line\ %l\\,\ col\ %c\\,\ Error\ -\ %m,%f:\ line\ %l\\,\ col\ %c\\,\ Warning\ -\ %m
CompilerSet makeprg=eslint\ --fix\ -f\ compact\ %

" automatically open quickfix window
" autocmd QuickFixCmdPost [^l]* nested cwindow
" autocmd QuickFixCmdPost    l* nested lwindow

" automatically run make on save
" autocmd BufWritePost <buffer> silent! make | redraw!

" Don't run the autocmds when forcing it
" Probably a better way of doing this as it introduces a visual delay
" nnoremap :w! :noautocmd w!

let &cpo = s:cpo_save
unlet s:cpo_save
