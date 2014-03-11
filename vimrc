" vim: set ts=2 sw=2 et :
""""""""""""""""
" Plugin Stuff
""""""""""""""""
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
imap ,n <C-R>=GetMetaSyntacticWord()<C-M>
map ,n "=GetMetaSyntacticWord()<C-M>p


"""""""""""
" General "
"""""""""""
set nocompatible    " get out of horrible vi-compatible mode
filetype indent on  " detect the type of file and load indent files
filetype plugin on  " load filetype plugins
syntax on           " syntax highlighting on

set history=1000    " How many lines of history to remember
" set cf              " enable error files and error jumping
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

" Scrolling, nicer scrolling when wrapping
set sidescroll=1
set sidescrolloff=10
set scrolloff=3

set omnifunc=syntaxcomplete#Complete


""""""""""
" Vim UI "
""""""""""
set lazyredraw          " do not redraw while running macros (much faster) (LazyRedraw)
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

" Super fancy status lines
set statusline=%2*%n:%0*%f\ %2*%m\ %1*%h%r%=%{fugitive#statusline()}[%{&fileformat}\ %{&encoding}\ %{strlen(&ft)?&ft:'none'}]\ 0x%B\ %12.(%c:%l/%L%)
" Allow for filetypes to define a FindSubName function
augroup statusline
  au!
  au VimEnter *.pm set statusline=%1*%n:%0*%f\ %2*%m\ \ %<%r%{FindSubName()}\ %1*%h%r%=%{fugitive#statusline()}[%{&fileformat}\ %{&encoding}\ %{strlen(&ft)?&ft:'none'}]\ 0x%B\ %12.(%c:%l/%L%)
augroup END

" Add a column indicating when you approach 80 columns
" " Make relative numbers appear on the left.
if version >= 703
  set number relativenumber " relative numbering
  set colorcolumn=80
else
  set number
endif
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
let mapleader = ","

" switch windows
map <tab> <C-W>w

nmap :W :w
nmap :X :x
nmap :Q :q

map <F2> :set hls!<CR>
map <F3> :set relativenumber!<CR>
map <F5> :set wrap!<CR>
set pastetoggle=<F6>
map <F7> :sp <cfile><CR>
map <F8> :vs <cfile><CR>

" ctrl-c saves and compiles
nmap ,c :w<cr>:make<cr>
imap ,c <esc>:w<cr>:make<cr>i

" Wrap visually, not by actual line
nmap j gj
nmap k gk

" Yank 'to end of line' like C and D
nnoremap Y y$

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif


"""""""""""""
" filetypes "
"""""""""""""
" create autocommands only once
augroup filetypes
  au!

  au BufNewFile,BufRead *.tt,*.xmlbez set filetype=tt2html.javascript.xhtml.css
  au BufNewFile,BufRead *.psgi,*.t set filetype=perl

  " Make tt files use snippets from xhtml, javascript and css
  au BufNewFile,BufRead *.tt UltiSnipsAddFiletypes xhtml.javascript.css

  " Load boiler plate files if they exist
  au BufNewFile * silent! 0r ~/.vim/skeleton/template.%:e

  " Set the sparkup filetypes
  autocmd FileType tt2html,php runtime! ftplugin/html/sparkup.vim

  " Set the compiler for perl
  au BufNewFile,BufRead *.pl,*.pm,*.t compiler perl

  " Automatically rewrite the skeleton file ::package:: line if appropriate
  " Function is defined in after/ftplugin/perl.vim
  autocmd BufNewFile *.pm call SetPerlPackageFromFile()
augroup END

