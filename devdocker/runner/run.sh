git clone --depth=1 https://github.com/HubiBoar/dotfiles ~/dotfiles
chmod -R 400 ~/.ssh
gh auth login --with-token < ~/.ssh/.githubtoken
echo "[CDE Is Running] (Ctrl-c to Detach)"
sleep infinity