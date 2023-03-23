#!/bin/zsh

if [[ $1 == "help" ]] || [[ $# != 1 ]]; then
    echo 'Usage: dotfiles [reload|update]'
fi

if [[ $1 == "reload" ]]; then
    echo 'Reloading \e[4m~/.zshrc\e[0m...'
    source ~/.zshrc
fi

if [[ $1 == "update" ]]; then
    echo 'Updating \e[4m~/.config/dotfiles\e[0m...'
    pushd ~/.config/dotfiles >/dev/null
    git pull
    popd >/dev/null
fi
