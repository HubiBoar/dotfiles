echo "\n --> Stow adopt downloaded dotfiles...\n"
stow --dir="/startup/dotfiles/" --target=$HOME --adopt -v .

echo "\n --> Installing Tmux plugins... \n"
~/.tmux/plugins/tpm/bin/install_plugins

echo "\n --> Setting up Nvim"
grep -qxF 'export PATH="$PATH:/opt/nvim-linux64/bin"' ~/.zshrc || echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.zshrc