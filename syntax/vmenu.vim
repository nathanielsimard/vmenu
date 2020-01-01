let b:current_syntax = 'vmenu'

syntax match menuCommandText '\v ([a-z,A-Z,0-9, ,\n])* '
syntax match menuCategaryText '\v \+([a-z,A-Z,0-9, ,\n])* '
syntax match menuKey '\v([a-z|A-Z|0-9|<|>|\-])*\ze\]'
syntax match menuTitle '\v ([a-z,A-Z,0-9, ,\-,+])*\ze\>'
syntax match menuBracket '\v\[|\]'
syntax match menuLBar '\v(\-)*\<'
syntax match menuRBar '\v\>(\-)*'

highlight link menuKey Tag
highlight link menuCommandText Function
highlight link menuCategaryText Keyword
highlight link menuLBar Comment
highlight link menuRBar Comment
highlight link menuBracket Delimiter

