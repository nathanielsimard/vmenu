let g:FakeMenu={}
function g:FakeMenu.new()
    let l:newMenu = copy(self)
    let l:newMenu.closed = 0
    let l:newMenu.showed = 0
    let l:newMenu.showed_args={}
    return l:newMenu
endfunction

function g:FakeMenu.close()
    let self.closed = 1
endfunction

function g:FakeMenu.show(title, keybindings)
    let self.showed = 1
    let self.showed_args['title'] = a:title
    let self.showed_args['keybindings'] = a:keybindings
endfunction

