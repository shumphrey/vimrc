" Vim syntax file for log4perl
"
if exists("b:current_syntax")
  finish
endif
syn match fatal ".* FATAL .*"
syn match fatal "^FATAL: .*"
syn match error ".* ERROR .*"
syn match error "^ERROR: .*"
syn match warn ".* WARN .*"
syn match warn "^WARN: .*"
syn match info ".* INFO .*"
syn match info "^INFO: .*"
syn match debug ".* DEBUG .*"
syn match debug "^DEBUG: .*"
syn match trace ".* TRACE .*"
syn match trace "^TRACE: .*"

" Highlight colors for log levels.
hi fatal ctermfg=Red ctermbg=Black
hi error ctermfg=LightRed ctermbg=Black
hi warn ctermfg=Yellow ctermbg=Black
hi info ctermfg=Blue ctermbg=Black
hi debug ctermfg=DarkGreen ctermbg=Black
hi trace ctermfg=Gray ctermbg=Black

let b:current_syntax = "log"
