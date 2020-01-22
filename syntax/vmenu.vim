let b:current_syntax = 'vmenu'

syntax match menuCommandText '\v ([a-z,A-Z,0-9, ,\n])* '
syntax match menuCategoryText '\v \+([a-z,A-Z,0-9, ,/,\n])* '

syntax match menuLBar '\v(\-)*\<'
syntax match menuRBar '\v\>(\-)*'

syntax match menuKey '\v([a-z|A-Z|0-9|<|>|\-])*\ze\]'
syntax match menuTitle '\v ([a-z,A-Z,0-9, ,\-,+])*\ze\>'
syntax match menuBracket '\v\[|\]'

highlight link menuKey Tag
highlight link menuCommandText Function
highlight link menuCategoryText Keyword
highlight link menuLBar Comment
highlight link menuRBar Comment
highlight link menuBracket Delimiter

