#!/bin/bash

if ! [ -x "$(command -v vunit)" ]; then
  echo 'Installing VUnit ...'
  echo 'Make sure "~/.local/bin" is in PATH'

  git clone https://github.com/nathanielsimard/vunit
  cd vunit
  ./install.sh
  cd ..
  rm -rf vunit
fi

vunit tests --nvim
vunit tests --vim

