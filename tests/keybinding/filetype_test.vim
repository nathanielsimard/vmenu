source ./tests/helper/menu.vim
source ./autoload/vmenu/keybinding.vim
source ./autoload/vmenu/keybinding/filetype.vim


let s:KEY='a'
let s:DESCRIPTION='description'
let s:FILETYPE='python'
let s:OTHER_FILETYPE='javascript'

let s:Test = Test('Filetype Keybinding Test')

function s:Test.before_each()
    let self.menu = g:FakeMenu.new()
    setlocal filetype=test
    if !has('nvim')
        " vint: -ProhibitSetNoCompatible
        set nocompatible 
    endif
endfunction

function s:Test.test_GivenKeybindingsWithoutFiletype_WhenExecute_ShouldAssignEachKeybindingToItsKey()
    let l:keybinding = vmenu#keybinding#filetype#new(s:KEY, s:DESCRIPTION)
    let l:sub_keybindings = self.givenKeybindings(l:keybinding)

    call l:keybinding.execute(self.menu)

    let l:actual_keybindings = self.menu.showed_args['keybindings'] 
    for sub_keybinding in l:sub_keybindings
        call self.assert_equal(l:actual_keybindings[sub_keybinding.key], l:sub_keybinding)
    endfor
endfunction

function s:Test.test_GivenKeybindingsWithFiletype_WhenExecuteWithSameFiletype_ShouldAssignEachKeybindingToItsKey()
    let l:keybinding = vmenu#keybinding#filetype#new(s:KEY, s:DESCRIPTION)
    let l:sub_keybindings = self.givenFiletypeKeybindings(s:FILETYPE, l:keybinding)

    execute 'setlocal filetype='.s:FILETYPE
    call l:keybinding.execute(self.menu)

    let l:actual_keybindings = self.menu.showed_args['keybindings'] 
    for sub_keybinding in l:sub_keybindings
        call self.assert_equal(l:actual_keybindings[sub_keybinding.key], l:sub_keybinding)
    endfor
endfunction

function s:Test.test_GivenPreviousFiletype_WhenCurrentFiletypeVMenu_ShouldReturnPreviousFiletype()
    let l:keybinding = vmenu#keybinding#filetype#new(s:KEY, s:DESCRIPTION)

    execute 'setlocal filetype='.s:FILETYPE
    setlocal buftype=nofile
    split vmenu
    setlocal filetype=vmenu
    setlocal buftype=nofile

    let l:filetype = l:keybinding.current_filetype()
    q

    call self.assert_equal(s:FILETYPE, l:filetype)
endfunction

function s:Test.test_GivenKeybindingsWithFiletype_WhenExecuteWithDifferentFiletype_ShouldShowNoKeybinding()
    let l:keybinding = vmenu#keybinding#filetype#new(s:KEY, s:DESCRIPTION)
    let l:sub_keybindings = self.givenFiletypeKeybindings(s:FILETYPE, l:keybinding)

    execute 'setlocal filetype='.s:OTHER_FILETYPE
    call l:keybinding.execute(self.menu)

    let l:actual_keybindings = self.menu.showed_args['keybindings'] 
    call self.assert_equal(len(l:actual_keybindings), 0)
endfunction

function s:Test.test_GivenKeybindingsWithFiletype_WhenExecuteWithDifferentFiletype_ShouldCloseMenu()
    let l:keybinding = vmenu#keybinding#filetype#new(s:KEY, s:DESCRIPTION)
    let l:sub_keybindings = self.givenFiletypeKeybindings(s:FILETYPE, l:keybinding)

    execute 'setlocal filetype='.s:OTHER_FILETYPE
    call l:keybinding.execute(self.menu)

    call self.assert_true(self.menu.closed)
endfunction

function s:Test.test_GivenKeybindingsWithoutFiletypeAndWithFiletype_WhenExecuteWithSameFiletype_ShouldShowAllKeybindings()
    let l:keybinding = vmenu#keybinding#filetype#new(s:KEY, s:DESCRIPTION)
    let l:sub_keybindings = self.givenKeybindings(l:keybinding)
    let l:sub_keybindings = l:sub_keybindings + self.givenFiletypeKeybindings(s:FILETYPE, l:keybinding)

    execute 'setlocal filetype='.s:FILETYPE
    call l:keybinding.execute(self.menu)

    let l:actual_keybindings = self.menu.showed_args['keybindings'] 
    for sub_keybinding in l:sub_keybindings
        call self.assert_equal(l:actual_keybindings[sub_keybinding.key], l:sub_keybinding)
    endfor
endfunction


function s:Test.test_GivenKeybindingsWithoutFiletypeAndWithFiletype_WhenExecuteWithDifferentFiletype_ShouldOnlyShowKeybindingWithoutFiletype()
    let l:keybinding = vmenu#keybinding#filetype#new(s:KEY, s:DESCRIPTION)
    let l:sub_keybindings = self.givenKeybindings(l:keybinding)
    let l:sub_filetype_keybindings = self.givenFiletypeKeybindings(s:FILETYPE, l:keybinding)

    execute 'setlocal filetype='.s:OTHER_FILETYPE
    call l:keybinding.execute(self.menu)

    let l:actual_keybindings = self.menu.showed_args['keybindings'] 
    for sub_keybinding in l:sub_keybindings
        call self.assert_equal(l:actual_keybindings[sub_keybinding.key], l:sub_keybinding)
    endfor
    for sub_filetype_keybinding in l:sub_filetype_keybindings
        let l:has_key = has_key(l:actual_keybindings, sub_filetype_keybinding.key)
        call self.assert_false(l:has_key)
    endfor
endfunction

function s:Test.givenKeybindings(keybinding)
    let l:first_keybinding = self.add_keybinding(a:keybinding, 'a', 'first keybinding')
    let l:second_keybinding = self.add_keybinding(a:keybinding, 'b', 'second keybinding')

    return [l:first_keybinding, l:second_keybinding]
endfunction

function s:Test.givenFiletypeKeybindings(filetype, keybinding)
    let l:first_keybinding = self.add_filetype_keybinding(a:filetype, a:keybinding, 'c', 'first "'.a:filetype.'" keybinding')
    let l:second_keybinding = self.add_filetype_keybinding(a:filetype, a:keybinding, 'd', 'second "'.a:filetype.'" keybinding')

    return [l:first_keybinding, l:second_keybinding]
endfunction

function s:Test.add_keybinding(category_keybinding, key, description)
    let l:keybinding = vmenu#keybinding#new(a:key, a:description)
    call a:category_keybinding.add(l:keybinding)
    return l:keybinding
endfunction

function s:Test.add_filetype_keybinding(filetype, category_keybinding, key, description)
    let l:keybinding = vmenu#keybinding#new(a:key, a:description)
    call a:category_keybinding.add_filetype(a:filetype, l:keybinding)
    return l:keybinding
endfunction

