""""""""""""""""
" Plugin Stuff
""""""""""""""""
" Pathogen for easy plugin installation
call pathogen#infect()


"""""""""""
" General "
"""""""""""

set nocompatible " get out of horrible vi-compatible mode
filetype on " detect the type of file
filetype plugin on " load filetype plugins
syntax on " syntax highlighting on
set history=1000 " How many lines of history to remember
set cf " enable error files and error jumping
" set ffs=dos,unix,mac " support all three, in this order
set viminfo+=! " make sure it can save viminfo
set isk+=_,$,@,%,#,- " none of these should be word dividers, so make them not be
set wildmode=list:longest,full

" Indenting level
set ts=4
set cindent shiftwidth=4
set et " Expand tabs to be spaces

" Search settings
set hls
set nohlsearch
set incsearch
set ignorecase smartcase " only search case sensitive if you include case

" Stop comments from being at the start of newline
set cinkeys-=0#
set indentkeys-=0#

" A more sensible file tab completion
set wildmode=longest,list,full
set wildmenu

"""""""""""""""""
" Theme/Colours "
"""""""""""""""""
set background=dark " we are using a dark background
" colorscheme elflord " my theme

" Set perl comment colour to be red
" highlight Comment ctermfg=red

" If there is a SOLARIZED ENV variable, set this scheme
if $SOLARIZED
colorscheme solarized
endif


"""""""""""""""""
" Files/Backups "
"""""""""""""""""
set nobackup
set nowritebackup


""""""""""
" Vim UI "
""""""""""
" set lsp=0 " space it out a little more (easier to read)
set ruler " Always show current positions along the bottom 
" set cmdheight=2 " the command bar is 2 high
set lz " do not redraw while running macros (much faster) (LazyRedraw)
set hid " you can change buffer without saving
set backspace=2 " make backspace work normal
set whichwrap+=<,>,h,l  " backspace and cursor keys wrap to
" set mouse=a " use mouse everywhere
" set shortmess=atI " shortens messages to avoid 'press a key' prompt 
set report=0 " tell us when anything is changed via :...
set noerrorbells " don't make noise
" make the splitters between windows be blank
" set fillchars=vert:\ ,stl:\ ,stlnc:\

" indicate when a line is wrapped by prefixing wrapped line with '> '
set showbreak=>\ 


"""""""""""""""
" Visual Cues "
"""""""""""""""
" show matching brackets
set showmatch
" how many tenths of a second to blink matching brackets for
set mat=4
" set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$ " what to show when I hit :set list
" set lines=80 " 80 lines tall
" set columns=160 " 160 cols wide
" set so=10 " Keep 10 lines (top/bottom) for scope
set novisualbell " don't blink
set noerrorbells " no noises
set laststatus=2 " always show the status line
" alternate statusline
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [POS=%04l,%04v][%p%%]
" set statusline=%f\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)
set statusline=%f\ %2*%m\ %1*%h%r%=%{fugitive#statusline()}[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)

""""""""""""""""
" Syntax stuff
""""""""""""""""
set omnifunc=syntaxcomplete#Complete

""""""""""""
" Mappings "
""""""""""""

" switch windows
map <tab> <C-W>w

nmap :W :w
nmap :X :x
nmap :Q :q

map <F2> :set hls!<CR>
" map <F3> :set number!<CR>
map <F5> :set wrap!<CR>
" map <F6> :set paste!<CR>
set pastetoggle=<F6>
map <F7> :sp <cfile><CR>
map <F8> :vs <cfile><CR>

map <F9> :s/^/#/g<CR>
map <F10> :s/^#//g<CR>

map <F11> gg:1,3s/^/#/G:s/^/#/

" shift-k for perldoc -f (uses standard vim options set by perl syntax)
" See perl.vim in ftplugins
map <F3> :!perldoc <cfile><CR>
" map <F12> :%!perltidy<CR>


nmap j gj
nmap k gk

"""""""""""""
" filetypes "
"""""""""""""
" Set template::toolkit files to use the tt2html syntax plugin
au BufNewFile,BufRead *.tt set filetype=tt2html
" Set JB process files to be filetype perl
au BufNewFile,BufRead process set filetype=perl
au BufNewFile,BufRead *.t set filetype=perl

""""""""""""
" Aliases  "
""""""""""""
iab xdate <c-r>=strftime("%y-%m-%d %H:%M:%S")<cr>
iab eric ERIC IS BANANAMAN!!!
" iab udd use Data::Dumper;
" iab ddd die(Dumper($

"""""""""""""
" Templates "
"""""""""""""
autocmd! BufNewFile * silent! 0r ~/.vim/skeleton/template.%:e

"""""""""""""""""""
" Compiler options
"""""""""""""""""""
let g:perl_compiler_force_warnings = 0
autocmd BufNewFile,BufRead *.pl compiler perl
autocmd BufNewFile,BufRead *.pm compiler perl
autocmd BufNewFile,BufRead *.t compiler perl
