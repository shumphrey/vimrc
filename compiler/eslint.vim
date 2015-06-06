if exists("current_compiler")
    finish
endif
let current_compiler = "perlcritic"

if exists(":CompilerSet") != 2 
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ Error\ -\ %m
CompilerSet makeprg=eslint\ -f\ compact\ %

" automatically open quickfix window
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" automatically run make on save
autocmd BufWritePost <buffer> silent! make | redraw!

let &cpo = s:cpo_save
unlet s:cpo_save
