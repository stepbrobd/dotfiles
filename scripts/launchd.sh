#!/usr/bin/env zsh

set -eo pipefail

if [[ $(uname) != "Darwin" ]]; then
    echo "\`launchd\` is only available on Darwin systems, skipping..."
    exit 0
else
    echo "Configuring \`launchd\`..."
fi

if [[ ! -d "${HOME}/Library/LaunchAgents" ]]; then
    mkdir -p "${HOME}/Library/LaunchAgents"
fi

for agent in "${HOME}/.config/dotfiles/launchd/"*.plist; do
    if [[ -f "${HOME}/Library/LaunchAgents/$(basename "${agent}")" ]]; then
        launchctl unload -w "${HOME}/Library/LaunchAgents/$(basename "${agent}")" >/dev/null 2>&1
        rm -f "${HOME}/Library/LaunchAgents/$(basename "${agent}")"
    fi

    cp "${agent}" "${HOME}/Library/LaunchAgents/$(basename "${agent}")"

    launchctl load -w "${HOME}/Library/LaunchAgents/$(basename "${agent}")" >/dev/null 2>&1
    launchctl enable gui/"$(id -u)"/"$(basename "${agent}" .plist)"

    echo " * Loaded $(basename "${agent}" .plist)"
done
