
" unlet! skip_defaults_vim
" silent! source $VIMRUNTIME/defaults.vim

let mapleader = "\<space>"

" General vim settings {{{
"""""""""""""""""""""""""
setglobal nocompatible  " get out of horrible vi-compatible mode
filetype indent on      " detect the type of file and load indent files
filetype plugin on      " load filetype plugins
syntax on               " syntax highlighting on

set history=1000          " How many lines of history to remember
set confirm               " confirm y/n dialog
set viminfo+=!,%          " Save buffer list so that vim reopens buffers, save capitalized variables
set iskeyword+=_,$,@,%,-  " none of these should be word dividers, so make them not be
set splitright            " vertical split opens on the right

" Indenting level
" Expand tabs to be spaces
" Let files override global settings
set modeline
set tabstop=8       " I never want tabs, so if a tab appears it should be long
set shiftwidth=4
set expandtab

set autoindent  " copy indent from current line
                " the file modules should set indentexpr and do the right
                " thing anyway

set shiftround  " << >> snap to multiples of shiftwidth
set smarttab    " <tab> at start applies shiftwidth, otherwise tabstop
                " No effect when sw and ts are the same

" Search settings
" only search case sensitive if you include case
set incsearch
set ignorecase smartcase

" A more sensible file tab completion
set wildmode=longest,list,full
set wildmenu
if has('popupwin')
    set completeopt=longest,menuone,popup
else
    set completeopt=longest,menuone,preview
endif

" Scrolling, nicer scrolling when wrapping
set sidescroll=1
set sidescrolloff=10
set scrolloff=3

" diffs open vertically by default
set diffopt+=vertical

" display as much of last line as possible
set display+=lastline

" always display tab chars
" always display trailing spaces
" always display > at end of nowrapped text
" set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set listchars=tab:>\ ,extends:>,precedes:<,nbsp:+
set list

" ctrl-x
"   ctrl-o -- omnifunc
"   ctrl-u -- completefunc
" see also, ctrl-n, ctrl-p, ctrl-f, ctrl-l, and more :help ins-completion

" Not sure what syntaxcomplete#Complete is giving me
" set omnifunc=syntaxcomplete#Complete

" use vim-emoji for completion
setglobal completefunc=emoji#complete

" Remove 'scan file' from ctrl-n/ctrl-p completion list
" (buffer is still scanned)
set complete-=i

"""""""""""""""""
" Files/Backups "
"""""""""""""""""
" set nobackup
" set nowritebackup " unclear why I want this... speed?
set autoread " auto reread if file hasn't changed in buffer

if has('persistent_undo')
    set undodir=~/.vim/tmp/undo//
    set undofile
    if !isdirectory(expand(&undodir))
        call mkdir(expand(&undodir), 'p')
    endif
endif

set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), 'p')
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), 'p')
endif

" if has('win32') || has('nvim')
if has('nvim')
    setglobal runtimepath^=~/.vim runtimepath+=~/.vim/after
endif

" }}}

" Vim UI settings {{{
"""""""""""""""""""""
set lazyredraw                  " no redraw while running macros for speed
set hidden                      " you can change buffer without saving
set backspace=indent,eol,start  " make backspace work normally, 'indent,eol,start'
" set whichwrap+=<,>,h,l          " backspace and cursor keys wrap over lines

" show matching brackets for 4 seconds
set showmatch
set matchtime=4
set novisualbell  " don't blink
set noerrorbells  " no noises

set ruler         " Always show current positions along the bottom
set laststatus=2  " always show the status line
set showcmd       " show the last command
set report=0      " Inform how many lines were changed by a command mode command

set formatoptions+=j " Delete comment character when joining commented lines
set formatoptions+=1 " don't break a line after a one-letter word, break before

" its in sensible.vim ... I should probably have this?
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
  runtime! macros/matchit.vim
endif

" Use the best diff algorithm
" Can also set iwhite and +indent
set diffopt+=algorithm:patience
" }}}

" Status Line {{{
""""""""""""""""""
" Super fancy status lines
function! s:statusline_expr()
  let mod  = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro   = "%{&readonly ? '[RO] ' : ''}"
  let ft   = "%0*%{len(&filetype) ? &filetype : 'unknown'}%2*"
  let fug  = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let pos  = ' %-12(%lL:%cC%V%) '
  let func = " %{exists('*FindSubName') ? FindSubName() : ''}"

  return '%2*%n:%0*%f %2*'.mod.func.' %1*%='.fug.'[%{&fileformat}/%{&encoding} '.ro.ft.'] 0x%B'.pos
endfunction
let &statusline = s:statusline_expr()

" When airline is installed...
let g:airline_section_c = "%{bufnr('%')}:%f %{&readonly ? '[RO] ' : ''} %{exists('*FindSubName') ? FindSubName() : ''}"
" let g:airline_section_y = 'BN:%{bufnr("%")}'
" let g:airline#extensions#tabline#enabled = 1

"}}}

" Mappings {{{
""""""""""""""

" switch windows
map <tab> <C-W>w

" Remap some common typos
nmap :W :w
nmap :X :x
nmap :Q :q
nmap :E :e
nmap :Sp :sp
nmap :Vs :vs
nmap :Bw :bw
nmap :Bn :bn " need to learn to use unimpaired [b ]b
nmap :Bp :bp


map <F2> :set hls!<CR>
map <F3> :set relativenumber!<CR>
map <F5> :set wrap!<CR>
set pastetoggle=<F6>
map <F7> :sp <cfile><CR>
map <F8> :vs <cfile><CR>

" space c saves and compiles
nmap <leader>c :w<cr>:make<cr>

" Wrap visually, not by actual line
nmap j gj
nmap k gk

" Yank 'to end of line' like C and D
nnoremap Y y$


" I want to be at the end of my paste after pasting
" I should be able to paste multiple times without mixing the pastes
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" I want space y, space p, etc to be like y and p but from system memory
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

" keep semantics of 'u' being undo, map ctrl-u to undo menu
map <silent> <C-u> :UndotreeToggle<CR>

" Force myself to use hjkl
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" I've opened a root file and forgotten sudo
cnoremap w!! w !sudo tee > /dev/null %

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

" %% expands to current directory in command mode
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

" ----------------------------------------------------------------------------
" <leader>ij | Open in IntelliJ
" <leader>vs | Open in VSCode
" ----------------------------------------------------------------------------
if has('mac')
  nnoremap <silent> <leader>ij :call system('nohup idea '.expand('%:p').'> /dev/null 2>&1 < /dev/null &')<cr>
  nnoremap <silent> <leader>vs :call system('nohup code '.expand('%:p').'> /dev/null 2>&1 < /dev/null &')<cr>
endif

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A
cnoremap <c-a> <home>
cnoremap <c-e> <end>

"}}}

" Autogroups {{{
""""""""""""""""

" create autocommands only once
augroup vimrc
    au!

    " Load boiler plate files
    " Because it reads content of template file above the current line we have a
    " blank line... delete it
    au BufNewFile * silent! 0r ~/.vim/skeleton/template.%:e | $d

    " Set the sparkup filetypes
    " au FileType tt,tt2html,php runtime! ftplugin/html/sparkup.vim

    " automatically load changes to these files
    au BufWritePost .vimrc.local ++nested source ~/.vimrc.local | silent! echom "Sourced vimrc"
    au BufWritePost vimrc ++nested source ~/.vim/vimrc | silent! echom "Sourced vimrc.local"

    " Save when losing focus
    au FocusLost * :silent! wall

    " Automatic rename of tmux window
    if exists('$TMUX') && !exists('$NORENAME')
        au BufEnter * if empty(&buftype) | call system('tmux rename-window '.expand('%:t:S')) | endif
        au VimLeave * call system('tmux set-window automatic-rename on')
    endif

    " exit paste mode when leaving insert mode
    au InsertLeave * silent! set nopaste
augroup END

"}}}

" Language settings {{{
""""""""""""""""""
" See after/ftplugin/<lang>
" }}}

" Plugin Settings {{{
"""""""""""""""""""""

""""""""""""""""
" ALE Settings "
""""""""""""""""
let g:ale_sign_column_always = 1


" after/ftplugin/<lang>.vim might set some of the linters
"
" let g:ale_linters = {}

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'javascript': ['eslint', 'remove_trailing_lines', 'trim_whitespace'],
      \ 'typescript': ['eslint', 'remove_trailing_lines', 'trim_whitespace'],
      \ 'markdown': [],
      \}

let g:ale_fix_on_save = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Use unimpaired style mappings
nmap ]a <Plug>(ale_next_wrap)
nmap [a <Plug>(ale_previous_wrap)

""""""""""""""""
" coc
""""""""""""""""

" vim-endwise conflicts with our coc mapping of enter
let g:endwise_no_mappings = 1
source ~/.vim/coc.vim

"}}}

" Plugins {{{
""""""""""""""""

call plug#begin()

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-unimpaired'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'tpope/vim-eunuch'
Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'AndrewRadev/linediff.vim'
Plug 'junegunn/vim-emoji'
  command! -range EmojiReplace <line1>,<line2>s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g

" Viml editing
Plug 'junegunn/vader.vim'
Plug 'tpope/vim-scriptease'

" Languages
Plug 'vim-perl/vim-perl'
Plug 'Glench/Vim-Jinja2-Syntax', { 'for': 'sls' }
Plug 'saltstack/salt-vim', { 'for': 'sls' }
Plug 'jelera/vim-javascript-syntax'
Plug 'tpope/vim-markdown'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'leafgarland/typescript-vim'
Plug 'cespare/vim-toml'
Plug 'vim-scripts/indentpython.vim' " fix indenting
Plug 'chr4/nginx.vim'
Plug 'neoclide/jsonc.vim'

" Theme stuff
" Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lifepillar/vim-solarized8' " a solarized that works

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" Lint & lang server
Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" My plugins
Plug 'shumphrey/fugitive-gitlab.vim'

" Plug 'shumphrey/scarletquarry'
Plug 'shumphrey/vim-perl-utils'
" Plug 'shumphrey/Vim-InPaste-Plugin'
" Plug 'shumphrey/Vim-Acme-MetaSyntactic'
"   imap <F10> <C-R>=GetMetaSyntacticWord()<C-M>
"   map <F10> "=GetMetaSyntacticWord()<C-M>p


" }}}

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

call plug#end()

" Theme/Colours {{{
"""""""""""""""""""
" Make vim use full colour range
" supported by iterm2 for example
" echo $COLORTERM -> truecolor
" theme may need overriding/replacing in ~/.vimrc.local
"
" iterm2 sets TERM to xterm-256color
" tmux sets TERM to screen-256color
" apparently tmux wants a screen or tmux based TERM
" setting TERM in zshrc is apparently bad practice
" So although "TERM=xterm-256color vim" seems to work, this is apparently better
" This plays nice with neovim :checkhealth also
if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
let g:solarized_termtrans = 1
let g:solarized_italics = 0
set background=dark
silent! colorscheme solarized8

" Add a column indicating when you approach 80 columns
set colorcolumn=80
hi ColorColumn ctermbg=darkgrey guibg=lightgrey
" }}}

" vim: set ts=2 sw=2 et foldmethod=marker :
