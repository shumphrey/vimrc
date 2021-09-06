" npm install --save-dev eslint

" same as prettier
set shiftwidth=2
set expandtab

" deprecated, coc.vim does this for us
function! s:aroundFunction()
    " search backwards for the word function
    if (!search('function', 'bzc', 0))
        return
    endif

    let l:lineNr = line('.')

    " set visual mode
    normal! v

    " search forwards for the opening bracket
    if (!search('{', 'zc', l:lineNr + 1))
        return
    endif

    " Jump to matching closing bracket
    normal! %
endfunction

function! s:insideFunction()
    " search backwards for the word function
    if (!search('function', 'bzc', 0))
        return
    endif

    let l:lineNr = line('.')

    " search forwards for the opening bracket
    if (!search('{', 'zc', l:lineNr + 1))
        return
    endif

    " move forward a character
    " start visual mode
    " move back
    " jump to matching bracket
    " move back a character
    normal! lvh%h
endfunction

onoremap <silent> af :<c-u>call <sid>aroundFunction()<cr>
xnoremap <silent> af :<c-u>call <sid>aroundFunction()<cr>

onoremap <silent> if :<c-u>call <sid>insideFunction()<cr>
xnoremap <silent> if :<c-u>call <sid>insideFunction()<cr>

setlocal suffixesadd=.js
