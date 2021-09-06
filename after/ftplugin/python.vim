" python -m pip install pylama mypy

if has_key(g:, 'ale_linters')
    let g:ale_linters.python = ['pylama', 'mypy']
endif
