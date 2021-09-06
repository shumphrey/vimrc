augroup perlftdetect
    au!

    " Automatically rewrite the skeleton file ::package:: line if appropriate
    " Function is defined in bundle/vim-perl-utils/ftplugin/perl.vim
    au BufNewFile *.pm call perl#change_package_from_filename()
augroup END
