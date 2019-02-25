" Plugins {{{
""""""""""""""""
let mapleader = "\<space>"

call plug#begin()

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'tpope/vim-eunuch'
Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-dispatch'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

" Viml editing
Plug 'junegunn/vader.vim'
Plug 'tpope/vim-scriptease', { 'for': 'vim' }

" Languages
Plug 'vim-perl/vim-perl'
Plug 'Glench/Vim-Jinja2-Syntax', { 'for': 'sls' }
Plug 'saltstack/salt-vim', { 'for': 'sls' }
Plug 'jelera/vim-javascript-syntax'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'tpope/vim-markdown'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'
Plug 'martinda/Jenkinsfile-vim-syntax'

" Theme stuff
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lifepillar/vim-solarized8' " a solarized that works

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" Lint
Plug 'w0rp/ale'

" My plugins
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'shumphrey/scarletquarry'
Plug 'shumphrey/vim-perl-utils'
Plug 'shumphrey/Vim-InPaste-Plugin'
Plug 'shumphrey/Vim-Acme-MetaSyntactic'

call plug#end()

" }}}

" General vim settings {{{
"""""""""""""""""""""""""
set nocompatible    " get out of horrible vi-compatible mode
filetype indent on  " detect the type of file and load indent files
filetype plugin on  " load filetype plugins
syntax on           " syntax highlighting on

set history=1000    " How many lines of history to remember
set confirm         " confirm y/n dialog
set viminfo+=!      " make sure it can save viminfo
set isk+=_,$,@,%,-  " none of these should be word dividers, so make them not be
set splitright      " vertical split opens on the right

" Indenting level
" Expand tabs to be spaces
" Let files override global settings
set modeline
set tabstop=4
set cindent shiftwidth=4
set expandtab

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
set completeopt=longest,menuone,preview

" Scrolling, nicer scrolling when wrapping
set sidescroll=1
set sidescrolloff=10
set scrolloff=3

" diffs open vertically by default
set diffopt+=vertical


" TODO: document this
set omnifunc=syntaxcomplete#Complete

"""""""""""""""""
" Files/Backups "
"""""""""""""""""
set nobackup
set nowritebackup
set autoread " auto reread if file hasn't changed in buffer

if has("persistent_undo")
    set undodir=~/.vim/undodir/
    set undofile
endif

" }}}

" Vim UI settings {{{
"""""""""""""""""""""
set lazyredraw          " no redraw while running macros for speed
set hidden              " you can change buffer without saving
set backspace=2         " make backspace work normally, 'indent,eol,start'
set whichwrap+=<,>,h,l  " backspace and cursor keys wrap over lines

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
let g:airline_section_c = "%f %{&readonly ? '[RO] ' : ''} %{exists('*FindSubName') ? FindSubName() : ''}"
" let g:airline#extensions#tabline#enabled = 1

"}}}

" Theme/Colours {{{
"""""""""""""""""""
" Make vim use full colour range
" supported by iterm2 for example
" echo $COLORTERM -> truecolor
" theme may need overriding/replacing in ~/.vimrc.local
set termguicolors
let g:solarized_termtrans = 1
set background=dark
colorscheme solarized8

" Add a column indicating when you approach 80 columns
set colorcolumn=80
hi ColorColumn ctermbg=darkgrey guibg=lightgrey
" }}}

" Mappings {{{
""""""""""""""

" switch windows
map <tab> <C-W>w

" Remap some common typos
nmap :W :w
nmap :X :x
nmap :Q :q

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

" numpad down for next in error list
map OA :cprev<CR>
map OB :cnext<CR>

" ctrl-up and ctrl-down
map <silent> [A :cprev<CR>
map <silent> [B :cnext<CR>

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


" Acme::MetaSyntactic
imap <F10> <C-R>=GetMetaSyntacticWord()<C-M>
map <F10> "=GetMetaSyntacticWord()<C-M>p

" Force myself to use hjkl
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" I've opened a root file and forgotten sudo
cnoremap w!! w !sudo tee > /dev/null %

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
  au FileType tt,tt2html,php runtime! ftplugin/html/sparkup.vim

  " Automatically rewrite the skeleton file ::package:: line if appropriate
  " Function is defined in bundle/vim-perl-utils/ftplugin/perl.vim
  au BufNewFile *.pm call perl#change_package_from_filename()
augroup END

"}}}

" Plugin Settings {{{
"""""""""""""""""""""

""""""""""""""""
" ALE Settings "
""""""""""""""""
let g:ale_sign_column_always = 1
let g:ale_yaml_yamllint_options = '-c ~/.config/yamllint/config'
let g:ale_perl_perlcritic_showrules = 1
let g:ale_perl_perl_options = '-c -Mwarnings -Ilib -It/lib'
let g:ale_linters = { 'javascript': ['eslint'], 'perl': ['perl', 'perlcritic'] }
let g:ale_fixers = {
            \ 'javascript': [
            \   'eslint',
            \   'remove_trailing_lines',
            \ ],
            \ 'perl': [
            \   'remove_trailing_lines',
            \ ],
            \}
let g:ale_fix_on_save = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Ultisnips local snippets and no warnings when no python
let g:UltiSnipsNoPythonWarning = 1
let g:UltiSnipsSnippetDirectories=["UltiSnips"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"}}}

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" vim: set ts=2 sw=2 et foldmethod=marker :
