" Command Keybinding Class
" Keybinding which execute a vim command and close the menu.
let s:CommandKeybinding={}
function! s:CommandKeybinding.new(key, description, command, menu) abort
    let l:newCommandKeybinding = vmenu#keybinding(a:key, a:description)
    let l:newCommandKeybinding.command = a:command
    let l:newCommandKeybinding.menu = a:menu
    return extend(l:newCommandKeybinding, copy(self))
endfunction

function! s:CommandKeybinding.execute() abort
    call self.menu.close()
    execute self.command
endfunction

function! vmenu#keybinding#command(key, description, command, menu) abort
    return s:CommandKeybinding.new(a:key, a:description, a:command, a:menu)
endfunction

