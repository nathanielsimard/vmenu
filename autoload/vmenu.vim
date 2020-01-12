let g:vmenu#menu = g:vmenu#menu#new()
let g:vmenu#root = vmenu#keybinding#filetype#new('root',  'VMenu')

function! vmenu#show() abort
    call g:vmenu#root.execute(g:vmenu#menu)
endfunction

function! vmenu#category(key, description, ...) abort
    if a:0 > 0
        let l:options = a:1
    else
        let l:options = {}
    endif

    let l:category = vmenu#keybinding#filetype#new(a:key, a:description)
    call s:add_keybinding(l:category, l:options)
    return l:category
endfunction

function! vmenu#commands(keybindings, ...) abort
    if a:0 > 0
        let l:options = a:1
    else
        let l:options = {}
    endif

    for l:keybinding in a:keybindings
        let l:key = l:keybinding[0]
        let l:description = l:keybinding[1]
        let l:command = l:keybinding[2]

        call vmenu#command(l:key, l:description, l:command, l:options)
    endfor
endfunction

function! vmenu#command(key, description, command, ...) abort
    if a:0 > 0
        let l:options = a:1
    else
        let l:options = {}
    endif

    let l:command = vmenu#keybinding#command#new(a:key, a:description, a:command)
    call s:add_keybinding(l:command, l:options)
endfunction

function! s:add_keybinding(keybinding, options) abort
    if has_key(a:options, 'parent')
        let l:parent = a:options['parent']
    else
        let l:parent = g:vmenu#root
    endif

    if has_key(a:options, 'filetype')
        call l:parent.add_filetype(a:options['filetype'], a:keybinding)
    else
        call l:parent.add(a:keybinding)
    endif
endfunction

