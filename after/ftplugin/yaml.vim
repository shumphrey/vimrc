setlocal ts=2 sw=2 et

" ------------
" SETUP
" ------------
" pip install yamllint
"
" cat <<EOF > ~/.config/yamllint/config
"   extends: relaxed
"   rules:
"     truthy:
"       level: warning
" EOF

if exists("g:ale_linters")
    if filereadable(expand("~/.config/yamllint/config"))
        let g:ale_yaml_yamllint_options = '-c ~/.config/yamllint/config'
    else
        let g:ale_yaml_yamllint_options = '-d relaxed'
    endif

    " this is the default
    " let g:ale_linters.yaml = ['yamllint']
endif
