" vim: set sw=4 ts=4 et :

""""""""""""""""""
" Functions
""""""""""""""""""

" Find what sub routine we're in
fun! FindSubName()
    let subpattern = '^\s*\(sub\|function\|method\) \w\+'
    let subline = search(subpattern, 'bnW')
    if !subline
        return ''
    else
        return matchstr(getline(subline), subpattern)
    endif
endfun

fun! ProveTestsInBuffers()
    let i = 1
    let tests = ''
    while (i <= bufnr("$"))
        let filename = bufname(i)
        if match(filename, '\.t$') > -1
            let tests = tests . ' "' . filename . '"'
        endif
        let i = i+1
    endwhile
    if !strlen(tests)
        echo "No tests found in buffers"
    else
        execute ':!prove ' . tests
    endif
endfun

" This only works with relative paths from the same directory
" as the cover database
fun! PerlCoverage()
    let file = bufname('%')
    if match(file, '\.t$') > -1
        execute '!covered by --test_file="'.file.'"'
    else
        execute '!covered covering --source_file="'.file.'"'
    end
endfun

fun! PerlRunCoverTests()
    let l:file = bufname('%')
    if match(l:file, '\.\(pl\|pm\)$') > -1
        let l:files = system('covered covering --source_file="'.l:file.'" | tr "\n" " "')
    else
        echo "Not a pl/pm file"
        return
        let l:files = ""
    endif
    let l:buff = bufwinnr("__Prove_Output__")
    if l:buff != -1
        exec l:buff . "wincmd w"
    else
        vsplit __Prove_Output__
        setlocal filetype=tap
        setlocal buftype=nofile
    endif
    setlocal modifiable
    normal! ggdG
    let lines = ["# Prove is running...",
                \"# Files:"]
    call setline(2, lines + map(split(files, "\v\s"), '"# * " . v:val'))
    redraw

    if l:files != ""
        let l:proveout = system('prove -mvl --norc '.l:files)
    else
        let l:proveout = "No files selected"
    endif
    normal! ggdG
    call append(0, split(l:proveout, '\v\n'))
    setlocal nomodifiable
    setlocal nowrap
    setlocal norelativenumber nonumber
    " limit the window size?
    " wincmd p
endfun

" todo: ...
" Run test with Dispatch.vim
fun! RunPerlTest()
    echo expand('%:e')
    if expand('%:e') == 't'
        let b:dispatch = './test_runner.pl -v % 2>/dev/stdout'
    endif

    if !exists('b:dispatch')
        echohl Error | echo ":call SetPerlTest('/path/to/test')" | echohl None
    else
        Dispatch
    endif
endfun

fun! SetPerlTest(file)
    let b:dispatch = './test_runner.pl -v ' . a:file . ' 2>/dev/stdout'
endfun

" noremap <buffer> <leader>t :!prove -vl %<CR>
" map <leader>tb :call ProveTestsInBuffers()<CR>
" map <leader>t :call RunPerlTest()<CR>
command! T call RunPerlTest()

function! PodFolds()
    let line       = getline(v:lnum)

    if line =~# '^=\(head\|item\)'
        return 1
    endif

    if line =~# '^=cut'
        return '<1'
    endif

    return '='
endfunction

setlocal foldmethod=expr
setlocal foldexpr=PodFolds()
setlocal equalprg=perltidy
