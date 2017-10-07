if exists("current_compiler")
    finish
endif
let current_compiler = "perl"

if exists(":CompilerSet") != 2 
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

if ! exists("b:perlcritic")
    let b:perlcritic = 4
endif

CompilerSet makeprg=~/.vim/compiler/perl_compiler.sh\ %

" perl -c errorformat
CompilerSet errorformat=
    \%f:%l:%c:%m,
    \%-G%.%#had\ compilation\ errors.,
    \%-G%.%#syntax\ OK,
    \%-G%.%#source\ OK,
    \%m\ at\ %f\ line\ %l\\,%.%#DATA%.%#,
    \%m\ at\ %f\ line\ %l.,
    \%+A%.%#\ at\ %f\ line\ %l\\,%.%#,
    \%+C%.%#,


" Explanation:
" %f:%l:%c:%m,                         - perlcritic error format
" %-G%f\ source\ OK,                   - ignore perlcritic source OK line
" %-G%.%#had\ compilation\ errors.,    - Ignore the obvious.
" %-G%.%#syntax\ OK,                   - Don't include the 'a-okay' message.
" %-G%.%#source\ OK,                   - Don't include the OK message
" %m\ at\ %f\ line\ %l\\,%.%#DATA%.%#, - perl 5.24 seems to add <DATA>, line 1
" %m\ at\ %f\ line\ %l.,               - Most errors...
" %+A%.%#\ at\ %f\ line\ %l\\,%.%#,    - As above, including ', near ...'
" %+C%.%#                              -   ... Which can be multi-line.
"                                      - %.%# gets replaced with .*

" automatically open quickfix window
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" automatically run make on save
" autocmd BufWritePost <buffer> silent! execute 'make ' . b:perlcritic | redraw!

" Don't run the autocmds when forcing it
" Probably a better way of doing this as it introduces a visual delay
" nnoremap :w! :noautocmd w!

let &cpo = s:cpo_save
unlet s:cpo_save
