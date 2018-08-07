" Prove Compiler plugin
" Compiler: provel
" Maintainer: Steven Humphrey <github.com/shumphrey>

if exists("current_compiler")
    finish
endif
let current_compiler = "prove"

if exists(":CompilerSet") != 2 
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" We only care about the STDERR when running inside vim?
CompilerSet makeprg=prove\ 2>/dev/stdout\ 1>/dev/null

CompilerSet errorformat=.*\%m\ at\ %f\ line\ %l
    " \%-Gok\ %.%#,
    " \%+Z%.%#

    " \%-G%f\ \.\.%.%#,
    " \%-G1\.\.%.%#,


    " \%-G%f\ %.%.,
    " \%Z#,

" TODO make it ignore the ./test_runner stuff and diagnostic info

" CompilerSet errorformat=
"     \%m\ at\ %f\ line\ %l.,
"     \%I#\ Looks\ like\ you\ %m%.%#,
"     \%Z\ %#,
"     \%I#\ \ \ \ \ Failed\ test\ (%f\ at\ line\ %l),
"     \%+Z#\ \ \ \ \ Tried\ to\ use%m,
"     \%E#\ \ \ \ \ Failed\ test\ (%f\ at\ line\ %l),
"     \%C#\ \ \ \ \ %m,
"     \%Z#\ %#%m,
"     \#\ %#Failed\ test\ (%f\ at\ line\ %l),
"     \%-G%.%#had\ compilation\ errors.,
"     \%-G%.%#syntax\ OK,
"     \%+A%.%#\ at\ %f\ line\ %l\\,%.%#,
"     \%+Z%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
