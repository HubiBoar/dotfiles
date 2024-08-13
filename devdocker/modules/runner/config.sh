echo "\n --> Downloading dotfiles from github...\n"
git clone --depth=1 https://github.com/HubiBoar/dotfiles ~/dotfiles

echo "\n --> Clearing previous .gitconfig...\n"
rm ~/.gitconfig -f

echo "\n --> Stow adopt downloaded dotfiles...\n"
stow --dir="$HOME/dotfiles" --adopt .

echo "\n --> Installing Tmux plugins...\n"
~/.tmux/plugins/tpm/bin/install_plugins

echo "\n --> Setting up Nvim"
echo 'export PATH="$PATH:/opt/nvim-linux64/bin" ' >> ~/.zshrc \