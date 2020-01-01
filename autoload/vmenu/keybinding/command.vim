" Command Keybinding Class
" Keybinding which execute a vim command and close the menu.
let s:CommandKeybinding={}
function! s:CommandKeybinding.new(key, description, command) abort
    let l:newCommandKeybinding = vmenu#keybinding#new(a:key, a:description)
    let l:newCommandKeybinding.command = a:command
    return extend(l:newCommandKeybinding, copy(self))
endfunction

function! s:CommandKeybinding.execute(menu) abort
    call a:menu.close()
    execute self.command
endfunction

function! vmenu#keybinding#command#new(key, description, command) abort
    return s:CommandKeybinding.new(a:key, a:description, a:command)
endfunction

