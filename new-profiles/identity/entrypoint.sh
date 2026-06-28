#!/bin/sh
set -e

cd "$HOME/projects"

exec /bin/zsh -lic 'exec nvim -u $HOME/.config/nvim/vimux_main.lua .'
