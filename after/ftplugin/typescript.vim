set suffixesadd+=.tsx,.js,.jsx

" same as prettier
set shiftwidth=2
set expandtab

if exists('g:ftplugin_typescript_load_file')
  finish
endif
let g:ftplugin_typescript_load_file = 1

" ESM require full extensions, e.g. /path/to/my/file.js
" Typescript will retain this .js extension if you put it in a typescript file
" Typescript will ignore the .js extension.
" However, it means `gf` "goto file" won't work, because there is no such file
" with a .js extension
function! FindTypescriptFile()
  let line = getline('.')

  " This is dumb
  " Really I should look forward from current position to find next quote
  " then backward from current pos to get last quote
  " This is buggy, but will probably work for most cases
  let match = matchstr(line, "[\"'][^\"']*[\"']")
  if empty(match)
    return
  endif
  let orig = match

  let name = substitute(match, '"', '', 'g')
  let name = substitute(name, "'", '', 'g')

  let name = substitute(name, '\.js$', '', '')
  let name = substitute(name, '\.cjs$', '', '')
  let name = substitute(name, '\.mjs$', '', '')
  let dir = expand('%:h')
  let tsname = dir . '/' . name . '.ts'
  let ctsname = dir . '/' . name . '.cts'
  let mtsname = dir . '/' . name . '.mts'
  let jsname = dir . '/' . name . '.js'
  let cjsname = dir . '/' . name . '.cjs'
  let mjsname = dir . '/' . name . '.mjs'

  for f in [tsname, ctsname, mtsname, jsname, cjsname, mjsname]
    if !empty(glob(expand(f)))
      exec 'edit ' . f
      return
    endif
  endfor

  echoerr name . ' does not exist'
endfunction

nnoremap gf :call FindTypescriptFile()<CR>
