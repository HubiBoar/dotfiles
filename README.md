#ZSH

sudo get-apt zsh


#PowerLevel10k

https://github.com/romkatv/powerlevel10k/blob/master/README.md


#ZSH-Autocompletion

https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#manual-git-clone


#Stow

sudo apt-get update -y
sudo apt-get install -y stow


#Instalation

```
git clone git@github.com:HubiBoar/dotfiles.git
cd dotfiles
```

then use GNU stow to create symlinks

```
$ stow .
```

or

```
$ stow --adopt .
```