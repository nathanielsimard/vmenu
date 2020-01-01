#!/bin/bash

# Installing Vint
pip install vim-vint

# Installing Vim
sudo apt-get install vim

# Installing Neovim
sudo apt-get install wget
wget https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage
chmod +x nvim.appimage
sudo mv nvim.appimage /usr/bin/nvim

# Installing VUnit
git clone https://github.com/nathanielsimard/vunit
cd vunit
sudo ./install.sh /usr
cd ..
rm -rf vunit

