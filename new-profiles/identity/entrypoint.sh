#!/bin/sh
set -e

cd "$HOME/.config"

exec /bin/zsh -lic 'exec nvim -u $HOME/.config/nvim/vimux.lua .'
