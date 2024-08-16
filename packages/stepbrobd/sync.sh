#!/usr/bin/env nix
#!nix shell nixpkgs#bash nixpkgs#jq nixpkgs#gh --command bash

set -euo pipefail

forks=$(gh repo list --limit 1000 --fork --json 'owner,name,parent')

echo "$forks" | jq -c '.[]' | while read -r repo; do
    own=$(echo "$repo" | jq -r '.owner.login + "/" + .name')
    upstream=$(echo "$repo" | jq -r '.parent.owner.login + "/" + .parent.name')
    echo "Syncing $own from $upstream"

    if [ "$upstream" = "/" ]; then
        echo "Skipped"
    else
        gh repo sync "$own" --source "$upstream"
        echo "Done"
    fi
done
