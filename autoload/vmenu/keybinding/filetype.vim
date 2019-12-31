" Filetype Keybinding Class
" Category keybinding aware of current filetype
let s:FiletypeKeybinding={}
function! s:FiletypeKeybinding.new(key, description, menu) abort
    let l:keybinding = vmenu#keybinding#category#new(a:key, a:description, a:menu)
    let l:keybinding.filetype_keybindings = {}
    return extend(l:keybinding, copy(self))
endfunction

function! s:FiletypeKeybinding.add_filetype(filetype, keybinding) abort
    if !has_key(self.filetype_keybindings, a:filetype)
        let self.filetype_keybindings[a:filetype] = {}
    endif

    let self.filetype_keybindings[a:filetype][a:keybinding.key] = a:keybinding
endfunction

function! s:FiletypeKeybinding.execute() abort
    let l:current_filetype = self.current_filetype()
    let l:keybindings = copy(self.keybindings)

    if has_key(self.filetype_keybindings, l:current_filetype)
        let l:keybindings = extend(l:keybindings, self.filetype_keybindings[l:current_filetype])
    endif

    if l:keybindings ==# {}
        call self.menu.close()
        echo '['.self.description."] No keybindings for filetype '".l:current_filetype."'"
    endif

    call self.menu.show(self.title(), l:keybindings)
endfunction

function! s:FiletypeKeybinding.current_filetype() abort
    let l:filetype = &filetype
    if l:filetype ==# 'vmenu'
        " Select the buffer type of the previous window
        " because the current one is the keybinding menu.
        wincmd p
        let l:filetype = &filetype
        wincmd p
    endif

    return l:filetype
endfunction

function! vmenu#keybinding#filetype#new(key, description, menu) abort
    return s:FiletypeKeybinding.new(a:key, a:description, a:menu)
endfunction

