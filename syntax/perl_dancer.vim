
syn match perlDancerKeyword "\<\%(any\)\>\s*\[.*\]\s*,"he=s+3 nextgroup=perlString
syn match perlDancerKeyword "^\s*\<\%(get\|post\|head\|put\|del\)\>" nextgroup=perlString
syn match perlDancerKeyword "\<\%(template\|to_json\|to_yaml\|from_json\|from_yaml\|param\|set\|redirect\|forward\)\>"

" Dancer
hi def link perlDancerKeyword       perlStatement
