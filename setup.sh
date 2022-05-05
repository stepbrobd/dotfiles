#!/bin/zsh

git clone https://github.com/StepBroBD/Dotfiles.git ~/.dotfiles/
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.dotfiles/zsh/zsh-autosuggestions/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.dotfiles/zsh/zsh-syntax-highlighting/

ln -fsv ~/.dotfiles/zsh/zshrc ~/.zshrc
ln -fsv ~/.dotfiles/gpg/gpg.conf ~/.gnupg/gpg.conf
ln -fsv ~/.dotfiles/git/gitconfig ~/.gitconfig
ln -fsv ~/.dotfiles/nvim ~/.config
