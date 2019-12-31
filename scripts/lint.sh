#!/bin/bash

if ! [ -x "$(command -v vint)" ]; then
  echo 'Installing Vint ...'
  echo 'Make sure "pip" is installed'
  pip install vim-vint
fi

vint .

