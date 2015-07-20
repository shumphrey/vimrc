" vim: set sw=4 ts=4 et :

""""""""""""""""""
" Functions
""""""""""""""""""

" Designed to work in conjuntion with the template.pm skeleton file
" Automatically replaces the package line with the appropriate name
fun! SetPerlPackageFromFile()
    " This expansion only has absolute path if the directory exists.
    " So package only gets set if the full path (not including filename)
    " exists
    let fname=expand('%:p')

    " Match anything with /lib/ or starting with lib/ or perl_lib/
    let index=matchend(fname, "[\</]lib/")
    if index == -1
        let index=matchend(fname, "[\</]perl_lib/")
    endif

    if index > -1
        let len=strlen(fname) - 3 - index
    else
        let firstchar = strpart(fname, 0, 1)
        if firstchar != "/"
            let len=strlen(fname) - 3
            let index=0
        endif
    endif

    if exists("len")
        let pname=strpart(fname, index, len)
        let parts=split(pname, '/')

        " Perl packages must start with a capital letter
        " So get rid of all parts that don't have an uppercase first letter
        let firstchar = strpart(get(parts, 0), 0, 1)
        while firstchar !=# toupper(firstchar) && len(parts) > 0
            let woo = remove(parts, 0)
            let firstchar = strpart(get(parts, 0), 0, 1)
        endwhile

        if len(parts) > 0
            let package=join(parts, '::')
            exec '1,$g/::package::/s/::package::/' . package
        endif
    endif
    return
endfun

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

noremap <buffer> <leader>t :!prove -vl %<CR>
map <leader>tb :call ProveTestsInBuffers()<CR>
