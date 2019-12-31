" Category Keybinding Class
" Keybinding which show the menu with sub-keybindings.
let s:CategoryKeybinding={}
function! s:CategoryKeybinding.new(key, description, menu) abort
    let l:newCategoryKeybinding = vmenu#keybinding#new(a:key, '+'.a:description)
    let l:newCategoryKeybinding.menu = a:menu
    let l:newCategoryKeybinding.keybindings = {}
    return extend(l:newCategoryKeybinding, copy(self))
endfunction

function! s:CategoryKeybinding.add(keybinding) abort
    let self.keybindings[a:keybinding.key] = a:keybinding
endfunction

function! s:CategoryKeybinding.title() abort
    return self.description[1:]
endfunction

function! s:CategoryKeybinding.execute() abort
    call self.menu.show(self.title(), self.keybindings)
endfunction

function! vmenu#keybinding#category#new(key, description, menu) abort
    return s:CategoryKeybinding.new(a:key, a:description, a:menu)
endfunction

