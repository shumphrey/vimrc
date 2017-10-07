" vim: set ts=2 sw=2 et :
""""""""""""""""
" Plugin Stuff
""""""""""""""""
let mapleader = "\<space>"

" Pathogen for easy plugin installation
call pathogen#infect()

" See https://github.com/Lokaltog/vim-powerline
let g:Powerline_symbols='fancy'

" Ultisnips local snippets and no warnings when no python
let g:UltiSnipsNoPythonWarning = 1
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snippets"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Acme::MetaSyntactic
imap <F10> <C-R>=GetMetaSyntacticWord()<C-M>
map <F10> "=GetMetaSyntacticWord()<C-M>p


"""""""""""
" General "
"""""""""""
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

" TODO: document this
set omnifunc=syntaxcomplete#Complete


""""""""""
" Vim UI "
""""""""""
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

" Super fancy status lines
set statusline=%2*%n:%0*%f\ %2*%m\ %1*%h%r%=%{fugitive#statusline()}[%{&fileformat}\ %{&encoding}\ %{strlen(&ft)?&ft:'none'}]\ 0x%B\ %12.(%c:%l/%L%)

" Allow for filetypes to define a FindSubName function
augroup statusline
  au!
  au VimEnter *.pm set statusline=%1*%n:%0*%f\ %2*%m\ \ %<%r%{FindSubName()}\ %1*%h%r%=%{fugitive#statusline()}[%{&fileformat}\ %{&encoding}\ %{strlen(&ft)?&ft:'none'}]\ 0x%B\ %12.(%c:%l/%L%)
augroup END

" Add a column indicating when you approach 80 columns
set colorcolumn=80
hi ColorColumn ctermbg=darkgrey guibg=lightgrey


"""""""""""""""""
" Theme/Colours "
"""""""""""""""""
set background=dark
" hi StatusLine cterm=bold ctermbg=white ctermfg=black
" hi StatusLineNC ctermbg=grey ctermfg=black

if $SOLARIZED
  colorscheme solarized
endif


"""""""""""""""""
" Files/Backups "
"""""""""""""""""
set nobackup
set nowritebackup
set autoread " auto reread if file hasn't changed in buffer


""""""""""""
" Mappings "
""""""""""""

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
" map OA :cprev<CR>
" map OB :cnext<CR>

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
map <silent> <C-u> :GundoToggle<CR>

"""""""""""""
" filetypes "
"""""""""""""
" create autocommands only once
augroup filetypes
  au!

  au BufNewFile,BufRead *.tt,*.xmlbez,*.tx set filetype=tt2html.javascript.html.css
  au BufNewFile,BufRead *.psgi,*.t,cpanfile set filetype=perl

  " Make tt files use snippets from xhtml, javascript and css
  " au BufNewFile,BufRead *.tt UltiSnipsAddFiletypes xhtml.javascript.css

  " Load boiler plate files
  " Because it reads content of template file above the current line we have a
  " blank line... delete it
  au BufNewFile * silent! 0r ~/.vim/skeleton/template.%:e | $d

  " Set the sparkup filetypes
  au FileType tt,tt2html,php runtime! ftplugin/html/sparkup.vim

  " Set the compiler for languages
  au BufNewFile,BufRead *.pl,*.pm,*.t compiler perl
  au BufNewFile,BufRead *.js compiler eslint

  " Automatically rewrite the skeleton file ::package:: line if appropriate
  " Function is defined in bundle/vim-perl-utils/ftplugin/perl.vim
  au BufNewFile *.pm call perl#change_package_from_filename()
augroup END
