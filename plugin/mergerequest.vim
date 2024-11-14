" A plugin for opening the Pull/Merge Request that 'merged' a commit in the browser
" API docs for GitHub and GitLab for determining PRs associated with commits
" https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28#list-pull-requests-associated-with-a-commit
" and
" https://docs.gitlab.com/ee/api/commits.html#list-merge-requests-associated-with-a-commit
" These two APIs are almost identical for this purpose
"
" I reckon this could live in the 3 existing fugitive gitlab/github plugins
" - a new handler callback in the same way rhubarb and fugitive-gitlab work
" - handler(remote, commit) -> url
" - fugitive can add mappings/commands to browse to the URL
"   - binding in Git Blame
"   - command for current line
" Perhaps it isn't really necessary to do in fugitive...
" would be too hard to come up with consistent naming given the different
" names the services use for pull/merge requests


" {{{fugitive browse function
" loosely cribbed from vim-fugitive
function! s:browse(url)
    if !exists('g:loaded_netrw')
        runtime! autoload/netrw.vim
    endif

    if exists('*netrw#BrowseX')
        call netrw#BrowseX(a:url, 0)
    elseif exists('*netrw#NetrwBrowseX')
        call netrw#NetrwBrowseX('.a:url.', 0)
    elseif has('nvim-0.10')
        echo luaeval("({vim.ui.open(_A)})[2] or _A", a:url)
    else
        echoerr 'Netrw not found'
    endif
endfunction
" }}}}}}

" {{{github handler
function! s:githubHandler(opts)
    let remote = get(a:opts, 'remote')
    let commit = get(a:opts, 'commit')
    let path   = substitute(get(a:opts, 'path', ''), '\.git$', '', '')

    let homepage = rhubarb#HomepageForUrl(remote)
    if empty(homepage)
        return
    endif

    " https://docs.github.com/en/rest/commits/commits?apiVersion=2022-11-28#list-pull-requests-associated-with-a-commit
    let apipath = '/repos/' . path . '/commits/' . commit . '/pulls'
    let res = rhubarb#Request(apipath)

    let url = ''
    if type(res) == type([]) && len(res) > 0
        if len(res) > 1
            echom 'More than one PR lists the commit, assuming first PR'
        endif
        let url = get(get(res, 0, {}), 'html_url', '')
    endif

    if empty(url)
        echom 'No PR is associated with commit ' . commit
        return
    endif

    return url
endfunction
"}}}

"{{{gitlab handler
function! s:gitlabHandler(opts)
    let remote = get(a:opts, 'remote')
    let commit = get(a:opts, 'commit')
    let path   = substitute(get(a:opts, 'path', ''), '\.git$', '', '')
    " encode me properly when this is moved to fugitive-gitlab
    let path = substitute(path, '/', '%2F', '')

    let root = gitlab#fugitive#homepage_for_remote(remote)
    if empty(root)
        return
    endif

    " https://docs.gitlab.com/ce/api/commits.html#list-merge-requests-associated-with-a-commit
    let res = gitlab#api#request('gitlab.com', '/projects/' . path . '/repository/commits/' . commit . '/merge_requests')

    let url = ''
    if type(res) == type([]) && len(res) > 0
        if len(res) > 1
            echom 'More than one MR lists the commit, assuming first MR'
        endif
        let url = get(get(res, 0, {}), 'web_url', '')
    endif

    if empty(url)
        echom 'No MR is associated with commit ' . commit
        return
    endif

    return url
endfunction
"}}}

" loop over handlers, support github/gitlab/etc
function! mergerequest#handleMergeUrl(commit)
    let remote = fugitive#Remote()

    let opts = { "remote": remote.url, "commit": a:commit, "path": remote.path }

    for l:.Handler in get(g:, 'fugitive_merge_url_handlers', [])
        let l:.url = call(Handler, [copy(opts)])
        if type(url) == type('') && url =~# '://'

            if has('clipboard')
                let @+ = url
            endif

            return s:browse(url)
        endif
    endfor
endfunction

" function called when cursor on line of file
" basic git blame to get commit
function! s:getCommitThatAuthoredLine()
    let line = line('.')
    let file = expand('%')
    " should parameterise -w somehow
    let blames = split(system(['git', 'blame', '-w', file]), '\n')
    let blame = split(blames[line - 1])[0]

    call mergerequest#handleMergeUrl(blame)
endfunction

"{{{mappings & config

if !exists('g:fugitive_merge_url_handlers')
    let g:fugitive_merge_url_handlers = []
endif

if index(g:fugitive_merge_url_handlers, function('s:githubHandler')) < 0
    call insert(g:fugitive_merge_url_handlers, function('s:githubHandler'))
endif
if index(g:fugitive_merge_url_handlers, function('s:gitlabHandler')) < 0
    call insert(g:fugitive_merge_url_handlers, function('s:gitlabHandler'))
endif


command! PR call s:getCommitThatAuthoredLine()

" Additional bindings in ftplugin/fugitiveblame.vim
" nnoremap <buffer> B :call mergerequest#handleMergeUrl(expand("<cword>"))<cr>
"}}}

" vim: set sw=4 et foldmethod=marker :
