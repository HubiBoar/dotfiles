#dotfiles and stow
git clone --depth=1 https://github.com/HubiBoar/dotfiles ~/dotfiles
stow --dir="$HOME/dotfiles" --adopt .

#tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins

#git and github ssh
chmod -R 400 ~/.ssh
gh auth login --with-token < ~/.ssh/.githubtoken

#finished
echo "[CDE Is Running] (Ctrl-c to Detach)"
sleep infinity