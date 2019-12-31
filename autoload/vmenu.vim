" Menu Options
let g:vmenu#type='floating'
let g:vmenu#show = 1
let g:vmenu#delay = 300

" Global Menu State
"
" INACTIVE: The user is not navigating the keybindings.
" SHOWING: The user is navigating the keybindings with a visible menu.
" HIDING: The user is navigating the keybindings with an invisible menu.
let g:vmenu#STATE_INACTIVE='inactive'
let g:vmenu#STATE_SHOWING='showing'
let g:vmenu#STATE_HIDING='hiding'

" User can interup the menu with <ESC>
let s:UserInteruptionException='User Interuption Exception'

" Menu Class
let s:Menu={}
function! s:Menu.new() abort
    let l:newMenu = copy(self)
    let l:newMenu.timer_id = -1
    let l:newMenu.state = g:menu#STATE_INACTIVE
    let l:newMenu.current_window = {}
    let l:newMenu.title = ''
    let l:newMenu.keybindings = {}
    return l:newMenu
endfunction

function! s:Menu.show(title, keybindings) abort
    let self.title = a:title
    let self.keybindings = a:keybindings

    if self.state == g:menu#STATE_SHOWING
        call self.draw()
    else
        let self.state = g:menu#STATE_HIDING
        let self.timer_id = timer_start(g:menu#delay, self.show_after_timer)
    endif

    try
        call self.execute_keybinding()
    catch 
        if match(v:exception, s:UserInteruptionException) < 0 " Not USER_INTERUPTION exception
            throw v:exception
        endif

        call self.close()
    endtry
endfunction

function! s:Menu.close() abort
    let self.state = g:menu#STATE_INACTIVE
    call self.close_window()
endfunction

function! s:Menu.close_window() abort
    if self.current_window !=# {}
        call self.current_window.close()
        let self.current_window = {}
    endif
endfunction


function! s:Menu.show_after_timer(timer_id) abort
    if self.timer_id == a:timer_id && self.state == g:menu#STATE_HIDING
        let self.state = g:menu#STATE_SHOWING
        call self.draw()
    endif
endfunction

function! s:Menu.execute_keybinding() abort
    let l:user_input = self.read_user()
    while !has_key(self.keybindings, l:user_input)
        let l:user_input = self.read_user()
    endwhile

    let l:keybinding = self.keybindings[l:user_input]
    try
        call l:keybinding.execute()
    catch
        echo '['.l:keybinding.description.'] Failed : '.v:exception
    endtry
endfunction

function! s:Menu.read_user() abort
    let l:user_input = getchar()
    if l:user_input == 27 "Escape caracter number
        throw s:UserInteruptionException
    endif

    return nr2char(l:user_input)
endfunction

function! s:Menu.draw() abort
    if g:menu#show !=# 1
        return
    endif

    let l:keybindings = s:sort_keybindings(self.keybindings)
    let l:default_padding = 20
    let l:tag_length = s:longuest_keybinding(l:keybindings) + l:default_padding
    let l:number_keybindings_per_line = s:number_keybindings_per_line(l:tag_length)
    let l:additional_padding = s:text_padding(l:tag_length, len(l:keybindings), l:number_keybindings_per_line)
    let l:tag_length = l:tag_length + l:additional_padding 

    let l:current_line_number = 1
    let l:current_tag_inline = 0
    let l:current_line_text = ''
    let l:text = [s:title_text(self.title)]

    for keybinding in l:keybindings
        if l:current_tag_inline == l:number_keybindings_per_line
            call add(l:text, l:current_line_text)

            let l:current_line_number = l:current_line_number + 1
            let l:current_tag_inline = 0
            let l:current_line_text = ''
        endif

        let l:current_text = s:create_keybinding_text(keybinding, l:tag_length)
        let l:current_line_text = l:current_line_text.l:current_text
        let l:current_tag_inline = l:current_tag_inline + 1
    endfor

    if l:current_tag_inline !=# 0 " If last line is not full
        call add(l:text, l:current_line_text)
    endif

    call self.close_window()
    if g:menu#type ==# 'floating'
        let self.current_window = s:FloatingWindow.new(l:text)
    else
        let self.current_window = s:BufferWindow.new(l:text)
    endif
    call self.current_window.open()
    redraw
endfunction

" Window Class (Abstract)
"
" Can be open and close displaying some text.
let s:Window={}
function! s:Window.new(text) abort
    let l:newWindow = copy(self)
    let l:newWindow.text = a:text
    let l:newWindow.win = -1
    return l:newWindow
endfunction

function! s:Window.close() abort
    if self.win !=# -1
        call nvim_win_close(self.win, 1)
    endif
endfunction

function! s:Window.open() abort
    throw 'Not implemented'
endfunction

" Buffer Window Class
"
" The window is created at the buttum of the screen
"   taking the full width.
let s:BufferWindow={}
function! s:BufferWindow.new(text) abort
    let l:newBufferWindow = s:Window.new(a:text)
    let l:newBufferWindow.name = 'BufferWindow'
    return extend(l:newBufferWindow, copy(self))
endfunction

function! s:BufferWindow.open() abort
    execute 'split '.self.name
    let self.win = win_getid()
    wincmd J
    setlocal filetype=keybindingMenu
    setlocal buftype=nofile
    setlocal norelativenumber
    setlocal nonumber
    call setline(1, self.text)
    let l:number_of_lines = len(self.text)
    execute 'resize '.l:number_of_lines
endfunction

" Floating Window Class
"
" The window is created at the buttum of the screen
"   taking the full width but overring the other windows.
let s:FloatingWindow={}
function! s:FloatingWindow.new(text) abort
    let l:newFloatingWindow = s:Window.new(a:text)
    return extend(l:newFloatingWindow, copy(self))
endfunction

function! s:FloatingWindow.open() abort
    let l:height = len(self.text)
    let l:width = &columns
    let opts = {
                \ 'relative': 'editor',
                \ 'row' : l:width,
                \ 'col' : 0,
                \ 'width': l:width,
                \ 'height': l:height
                \}

    let l:buf = nvim_create_buf(v:false, v:true)
    let self.win = nvim_open_win(l:buf, v:true, opts)
    call setline(1, self.text)

    setlocal filetype=keybindingMenu
    setlocal buftype=nofile
    setlocal norelativenumber
    setlocal nonumber
endfunction

function! s:title_text(title) abort
    let l:text = ''
    let l:number_padding = float2nr(floor((&columns - len(a:title) - 4) / 2))
    let l:current_padding = l:number_padding
    while l:current_padding > 0
        let l:text = l:text.'-'
        let l:current_padding = l:current_padding - 1
    endwhile

    let l:text = l:text.'< '.a:title.' >'.l:text
    if (l:number_padding * 2) < &columns
        let l:text = l:text.'-'
    endif
    return l:text
endfunction

function! s:text_padding(tag_length, number_keybindings, number_keybindings_per_line) abort
    let l:number_keybindings_per_line = a:number_keybindings_per_line
    if a:number_keybindings_per_line > a:number_keybindings
        let l:number_keybindings_per_line = a:number_keybindings
    endif

    return float2nr(floor((&columns - a:tag_length * l:number_keybindings_per_line) / l:number_keybindings_per_line))
endfunction

function! s:create_keybinding_text(keybinding, tag_length) abort
    let l:text = ' ['.a:keybinding.key.'] '.a:keybinding.description
    let l:padding = a:tag_length - len(l:text)

    while l:padding >= 0
        let l:text = l:text.' '
        let l:padding = l:padding - 1
    endwhile

    return l:text
endfunction

function! s:number_keybindings_per_line(tag_length) abort
    let l:width = &columns
    return float2nr(floor(l:width / a:tag_length))
endfunction

function! s:longuest_keybinding(keybindings) abort
    let l:current_length = 0

    for keybinding in a:keybindings
        let l:length = len(keybinding.description)
        if l:length > l:current_length
            let l:current_length = l:length
        endif
    endfor

    return l:current_length
endfunction

function! s:sort_keybindings(keybindings) abort
    let l:keybindings = values(a:keybindings)
    let l:keybindings_command = []
    let l:keybindings_category = []

    for keybinding in l:keybindings
        if keybinding.description[0] ==# '+'
            call add(keybindings_category, keybinding)
        else
            call add(keybindings_command, keybinding)
        endif
    endfor

    return l:keybindings_command + l:keybindings_category
endfunction

