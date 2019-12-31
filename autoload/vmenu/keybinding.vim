" Keybinding Class (Abstract)
" Each keybinding has a key and a description.
"
" Each keybinding class can be executed with the help of the 'execute' function.
let s:Keybinding={}
function! s:Keybinding.new(key, description) abort
    let l:newKeybinding = copy(self)
    let l:newKeybinding.key = a:key
    let l:newKeybinding.description = a:description
    return l:newKeybinding
endfunction

function! s:Keybinding.execute() abort
    throw 'Not Implemented'
endfunction

function! vmenu#keybinding#new(key, description) abort
    return s:Keybinding.new(a:key, a:description)
endfunction

