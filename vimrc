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
set statusline=%f\ %2*%m\ %1*%h%r%=%{fugitive#statusline()}[%{&fileformat}\ %{&encoding}\ %{strlen(&ft)?&ft:'none'}]\ 0x%B\ %12.(%c:%l/%L%)

" Add a column indicating when you approach 80 columns
" Make relative numbers appear on the left.
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

" If there is a SOLARIZED ENV variable, set this scheme
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
  au BufNewFile,BufRead *.tt set filetype=tt2html.xhtml.javascript.css
  au BufNewFile,BufRead *.psgi,*.t set filetype=perl

  " Make tt files use snippets from xhtml, javascript and css
  au BufNewFile,BufRead *.tt UltiSnipsAddFiletypes xhtml.javascript.css

  " Load boiler plate files if they exist
  au BufNewFile * silent! 0r ~/.vim/skeleton/template.%:e

  " Set the compiler for perl
  au BufNewFile,BufRead *.pl,*.pm,*.t compiler perl

  " Set the sparkup filetypes
  autocmd FileType tt2html,php runtime! ftplugin/html/sparkup.vim

  " Automatically rewrite the skeleton file ::package:: line if appropriate
  autocmd BufNewFile *.pm call SetPerlPackageFromFile()
augroup END


""""""""""""
" Aliases  "
""""""""""""
iab xdate <c-r>=strftime("%y-%m-%d %H:%M:%S")<cr>
iab eric ERIC IS BANANAMAN!!!


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
