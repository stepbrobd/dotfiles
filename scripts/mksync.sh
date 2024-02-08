#!/usr/bin/env nix
#!nix shell nixpkgs#bash nixpkgs#jq nixpkgs#gh --command bash

set -euo pipefail

forks=$(gh repo list --limit 1000 --fork --json 'owner,name,parent')

echo "$forks" | nix run nixpkgs#jq -- -c '.[]' | while read -r repo; do
    own=$(echo $repo | jq -r '.owner.login + "/" + .name')
    upstream=$(echo $repo | jq -r '.parent.owner.login + "/" + .parent.name')
    gh repo sync $own --source $upstream
done
