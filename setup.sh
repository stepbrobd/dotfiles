#!/bin/zsh

git clone git@github.com:Yifei-S/Dotfiles.git ~/.dotfiles/

ln -fsv ~/.dotfiles/zsh/zshrc ~/.zshrc
ln -fsv ~/.dotfiles/vim/vimrc ~/.vimrc
ln -fsv ~/.dotfiles/git/gitconfig ~/.gitconfig
