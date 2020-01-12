let g:vmenu#menu = g:vmenu#menu#new()

function! vmenu#category(key, description, ...) abort
    if a:0 > 1
        let l:options = a:1
    else
        let l:options = {}
    endif

    let l:category = vmenu#keybinding#filetype#new(a:key, a:description)
    call s:add_keybinding(l:category, l:options)
    return l:category
endfunction

function! vmenu#command(key, description, command, ...) abort
    if a:0 > 1
        let l:options = a:1
    else
        let l:options = {}
    endif

    let l:command = vmenu#keybinding#command#new(a:key, a:description, a:command)
    call s:add_keybinding(l:command, l:options)
    return l:command
endfunction

function! s:add_keybinding(keybinding, options) abort
    if has_key(a:options, 'parent')
        let l:parent = a:options['parent']
    else
        let l:parent = g:vmenu#menu
    endif

    if has_key(a:options, 'filetype')
        call l:parent.add_filetype(a:options['filetype'], a:keybinding)
    else
        call l:parent.add(a:options, a:keybinding)
    endif
endfunction

