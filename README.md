# Dotfiles for Linux

### ZSH

sudo get-apt zsh


## PowerLevel10k

https://github.com/romkatv/powerlevel10k/blob/master/README.md


## ZSH-Autocompletion

https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#manual-git-clone


## Stow

```
sudo apt-get update -y
sudo apt-get install -y stow
```

## Instalation

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

## Windows

### Terminal

```
cp ~/dotfiles/windows-terminal/settings.json ${windowsUserProfile}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState
```

### VsCode

```
cp ~/dotfiles/vscode/settings.json ${windowsUserProfile}/AppData/Roaming/Code/User
cp ~/dotfiles/vscode/keybindings.json ${windowsUserProfile}/AppData/Roaming/Code/User

cp ~/dotfiles/vscode/extensions.json ${windowsUserProfile}/.vscode/extensions
```
