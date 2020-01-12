# VMenu

(Neo)Vim Menu that maps keys to actions inspired by [Spacemacs](https://www.spacemacs.org/).

![example](./figures/demo.gif)

## Install

You can use your favorite vim plugin manager.
An example with [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'nathanielsimard/vmenu'
```

## Vim Users

Vim needs to be in `nocompatible` mode to use the filetype keybindings.

```vim
set nocompatible
```

## Usage

We are building a graph that can be navigated with keybindings.
First, we need to define what keybinding we will use to show the vmenu.

```vim
nnoremap <silent> <Space> :call vmenu#show()<CR>
```

There is two things that we can do, add a category to show more keybindings or add directly a keybinding that executes a command.
We can start be defining some categories.

```vim
let g:vmenu_buffer = vmenu#category('b', 'Buffer')
let g:vmenu_window = vmenu#category('w', 'Window')
let g:vmenu_help = vmenu#category('h', 'Help')
```

The first argument is the key that is used to open the menu and the second argument is the description. 
It is possible to add a menu into another menu to create submenu by adding the `parent` option.

```vim
let g:vmenu_help_doc = vmenu#category('d', 'Documentation', { 'parent': g:vmenu_help})
```

Now, we probably want to define some commands.

```vim
call vmenu#commands([
            \['Q', 'Quit', 'qa'],
            \['s', 'Save File', 'w'],
            \['S', 'Save All Files', 'wa'],
            \["'", 'Terminal', 'terminal']
        \])
```

Each keybinding is defined by a list of 3 items: the key, the description and the command in order.
But we also want to add some keybindings into the categories we defined above.

```vim
call vmenu#commands([
            \['q', 'Quit Window', 'q'],
            \['L', 'Add Vertical Space', 'vertical resize +5'],
            \['H', 'Remove Vertical Space', 'vertical resize -5'],
            \['J', 'Add Horizontal Space', 'res +5'],
            \['K', 'Remove Horizontal Space', 'res -5'],
            \['h', 'Focus Left', 'wincmd h'],
            \['j', 'Focus Down',  'wincmd j'],
            \['k', 'Focus Top',  'wincmd k'],
            \['l', 'Focus Right',  'wincmd l'],
            \['v', 'Split Vertical',  'call VerticalSplit()'],
            \['b', 'Split Horizontal',  'call HorizontalSplit()']
        \], {
            \'parent': g:vmenu_window
        \})
```

The keybindings without the `parent` option will be available at the root of the menu.
It is also possible to add some keybindings that will only be active for a specific filetype.

```vim
call vmenu#commands([
            \['g', 'Generate Doc', 'Pydocstring']
        \], {
            \'parent': g:vmenu_help_doc,
            \'filetype': 'python'
        \})
```

### Object Oriented API

It is possible to directly use the keybinding objects to build the menu.
First, we can define the root and the native vim keybinding to show the vmenu.

```vim
let g:menu = vmenu#new() " Everything is an object, even the menu.
let g:keybindings_root = vmenu#keybinding#category#new('no important', 'Keybinding Menu')
nnoremap <silent> <Space> :call g:keybindings_root.execute(g:menu)<CR>
```

But there is no keybindings to show, we need to add some.
For example, we may want to add a keybinding to show all open buffers.

```vim
call g:keybindings_root.add(vmenu#keybinding#command#new('b', 'List All Buffers', 'buffers'))
```

But what if we want to have another menu that list all the actions available on buffers with `b`.
We can create another category keybinding object and then add the `List All Buffers` keybinding.

```vim
let g:keybindings_buffer = vmenu#keybinding#category#new('b', 'Buffer')
call g:keybindings_buffer.add(vmenu#keybinding#command#new('b', 'List All Buffers', 'buffers'))
call g:keybindings_buffer.add(vmenu#keybinding#command#new('n', 'Next Buffer', 'bn'))
...
```

Also, we must not forget to add the new category keybinding to the root.

```vim
call g:keybindings_root.add(g:keybindings_buffer)
```

It is possible to have category keybindings that are aware of the current filetype to only show the appropriate keybindings.

```vim
let g:keybindings_refactor = vmenu#keybinding#filetype#new('r', 'Refactoring')
call g:keybindings_refactor.add(vmenu#keybinding#command#new('a', 'Alway visible', 'AlwaysVisibleCommand'))
call g:keybindings_refactor.add_filetype('python', vmenu#keybinding#command#new('f', 'Format File', 'PythonFormaterCommand'))
call g:keybindings_refactor.add_filetype('c', vmenu#keybinding#command#new('f', 'Format File', 'CFormaterCommand'))
...
```

In this example, the `Format File` option will only be displayed on `python` and `c` files and use the appropriate formater for each filetype.

## Limitations

In order to have zero side-effect with other keybindings, the implementation does not use `map`, `nmap`, etc.
For now, it means that only one caracter key can be set for each menu entry,
Also, keys like `<S-a>` or `<S-2>` are not supported, just use the corresponding caracter `A` or `@`.

