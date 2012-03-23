if exists("did_load_filetypes")
finish
endif

augroup filetypedetect
au! BufRead,BufNewFile *.out,*.out.*,*.log,*.log.* setf log
augroup END
