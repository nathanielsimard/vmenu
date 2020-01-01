source ./tests/helper/menu.vim
source ./autoload/vmenu/keybinding.vim
source ./autoload/vmenu/keybinding/command.vim


let s:KEY='a'
let s:DESCRIPTION='description'
let s:VALID_COMMAND='let g:a_command = "a value"'

let s:Test = Test('Command Keybinding Test')

function s:Test.before_each()
    let self.menu = g:FakeMenu.new()
endfunction

function s:Test.test_WhenExecute_ShouldCloseMenu()
    let l:keybinding = vmenu#keybinding#command#new(s:KEY, s:DESCRIPTION, s:VALID_COMMAND)
    call l:keybinding.execute(self.menu)
    call self.assert_equal(self.menu.closed, 1)
endfunction

function s:Test.test_GivenValidCommand_WhenExecute_ShouldExecuteCommand()
    let l:command = 'let g:command_executed = 1'
    let g:command_executed = 0
    let l:keybinding = vmenu#keybinding#command#new(s:KEY, s:DESCRIPTION, l:command)

    call l:keybinding.execute(self.menu)

    call self.assert_true(g:command_executed)
endfunction

