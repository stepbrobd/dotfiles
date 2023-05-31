#!/usr/bin/env zsh

set -eo pipefail

if [[ $(uname) != "Darwin" ]]; then
    exit 0
fi

if [[ ! -d "${HOME}/Library/LaunchAgents" ]]; then
    mkdir -p "${HOME}/Library/LaunchAgents"
fi

for agent in "${HOME}/.config/dotfiles/launchd/"*.plist; do
    ln -sf "${agent}" "${HOME}/Library/LaunchAgents/"
    launchctl load "${HOME}/Library/LaunchAgents/$(basename "${agent}")"
done
