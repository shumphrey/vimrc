if exists("current_compiler")
    finish
endif
let current_compiler = "jshint"

if exists(":CompilerSet") != 2 
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" js/views.js: line 14, col 58, Missing semicolon.
CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
CompilerSet makeprg=jshint\ %
"
" automatically open quickfix window
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" automatically run make on save
autocmd BufWritePost <buffer> silent! make | redraw!

let &cpo = s:cpo_save
unlet s:cpo_save
