" Highlight trailing whitespace
syn match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=red guibg=red
syntax sync fromstart
