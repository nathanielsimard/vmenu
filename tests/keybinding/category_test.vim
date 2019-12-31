source ./tests/helper/menu.vim
source ./autoload/vmenu/keybinding.vim
source ./autoload/vmenu/keybinding/category.vim


let s:KEY='a'
let s:DESCRIPTION='description'

let s:Test = Test('Category Keybinding Test')

function s:Test.before_each()
    let self.menu = g:FakeMenu.new()
endfunction

function s:Test.test_WhenExecute_ShouldShowMenu()
    let l:keybinding = vmenu#keybinding#category#new(s:KEY, s:DESCRIPTION, self.menu)
    call l:keybinding.execute()
    call self.assert_true(self.menu.showed)
endfunction

function s:Test.test_WhenExecute_ShouldShowTitleAsDescription()
    let l:keybinding = vmenu#keybinding#category#new(s:KEY, s:DESCRIPTION, self.menu)
    call l:keybinding.execute()
    call self.assert_equal(self.menu.showed_args['title'], s:DESCRIPTION)
endfunction

function s:Test.test_GivenNoKeybinding_WhenExecute_ShouldShowNoKeybinding()
    let l:keybinding = vmenu#keybinding#category#new(s:KEY, s:DESCRIPTION, self.menu)
    call l:keybinding.execute()
    call self.assert_equal(len(self.menu.showed_args['keybindings']), 0)
endfunction

function s:Test.test_GivenKeybindings_WhenExecute_ShouldAssignEachKeybindingToItsKey()
    let l:keybinding = vmenu#keybinding#category#new(s:KEY, s:DESCRIPTION, self.menu)
    let l:first_keybinding = self.add_keybinding(l:keybinding, 'a', 'first keybinding')
    let l:second_keybinding = self.add_keybinding(l:keybinding, 'b', 'second keybinding')

    call l:keybinding.execute()

    let l:actual_keybindings = self.menu.showed_args['keybindings'] 
    call self.assert_equal(l:actual_keybindings[l:first_keybinding.key], l:first_keybinding)
    call self.assert_equal(l:actual_keybindings[l:second_keybinding.key], l:second_keybinding)
endfunction

function s:Test.add_keybinding(category_keybinding, key, description)
    let l:keybinding = vmenu#keybinding#new(a:key, a:description)
    call a:category_keybinding.add(l:keybinding)
    return l:keybinding
endfunction

