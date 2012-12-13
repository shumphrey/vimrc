""""""""""""""""
" Plugin Stuff
""""""""""""""""
" Pathogen for easy plugin installation
call pathogen#infect()

" See https://github.com/Lokaltog/vim-powerline
let g:Powerline_symbols='fancy'

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
set isk+=_,$,@,%,- " none of these should be word dividers, so make them not be
set wildmode=list:longest,full
set splitright " vertical split opens on the right

" Indenting level
" Expand tabs to be spaces
set ts=4
set cindent shiftwidth=4
set et

" Search settings
" only search case sensitive if you include case
set hls
set nohlsearch
set incsearch
set ignorecase smartcase

" Stop comments from being at the start of newline
set cinkeys-=0#
set indentkeys-=0#

" A more sensible file tab completion
set wildmode=longest,list,full
set wildmenu

" Scrolling, nicer scrolling when wrapping
set sidescroll=1
set sidescrolloff=10
set scrolloff=3

"""""""""""""""""
" Theme/Colours "
"""""""""""""""""
set background=dark " we are using a dark background
" colorscheme elflord 

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
set ruler " Always show current positions along the bottom 
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
" set showbreak=>\ 


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

" Super fancy status lines
set statusline=%f\ %2*%m\ %1*%h%r%=%{fugitive#statusline()}[%{&fileformat}\ %{&encoding}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)

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
map <F12> :%!perltidy -i=2 -st<CR>
vmap <F12> :!perltidy -i=2 -st<CR>


" Wrap visually, not by actual line
nmap j gj
nmap k gk

"""""""""""""
" filetypes "
"""""""""""""
" autocmd! " reset autocommands incase reloading vimrc
" Set template::toolkit files to use the tt2html syntax plugin
au BufNewFile,BufRead *.tt set filetype=tt2html
" Set JB process files to be filetype perl
au BufNewFile,BufRead process set filetype=perl
au BufNewFile,BufRead *.psgi set filetype=perl
au BufNewFile,BufRead *.t set filetype=perl

""""""""""""
" Aliases  "
""""""""""""
iab xdate <c-r>=strftime("%y-%m-%d %H:%M:%S")<cr>
iab eric ERIC IS BANANAMAN!!!

"""""""""""""
" Templates "
"""""""""""""
autocmd BufNewFile * silent! 0r ~/.vim/skeleton/template.%:e|call SetInviewPackage()
" set verbose=9

"""""""""""""""""""
" Compiler options
"""""""""""""""""""
let g:perl_compiler_force_warnings = 0
autocmd BufNewFile,BufRead *.pl compiler perl
autocmd BufNewFile,BufRead *.pm compiler perl
autocmd BufNewFile,BufRead *.t compiler perl


""""""""""""""""""
" Functions
""""""""""""""""""
fun! SetInviewPackage()
    let fname=expand('%:p')

    let paths=['/opt/inview/perl_lib', '/home/shumphrey/git/perl_lib', '/opt/inview/web_internal/lib', '/home/shumphrey/web_internal/lib','/home/shumphrey/Projects/web_internal/lib','/home/shumphrey/Projects/infra_interim/perl_lib']
    for path in paths
        let index=matchend(fname, path)
        if index > -1
            let len=strlen(fname) - 3 - index
            let pname=strpart(fname, index, len)
            let parts=split(pname, '/')
            let package=join(parts, '::')
            exec '1,$g/::package::/s/::package::/' . package
            return
        endif
    endfor
endfun

"""""""""""""""""""""""""""""""""""""""""""
" enable snipmate and sparkup for tt2html
"""""""""""""""""""""""""""""""""""""""""""

augroup sparkup_types
  autocmd!
  autocmd FileType tt2html,php runtime! ftplugin/html/sparkup.vim
augroup END
