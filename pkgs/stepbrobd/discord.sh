#!/usr/bin/env nix
#!nix shell nixpkgs#bash nixpkgs#curl nixpkgs#jq nixpkgs#gh --command bash

set -euo pipefail

TOKEN=$TOKEN
WEBHOOK=$WEBHOOK

repos=$(gh repo list --limit 1000 --json nameWithOwner)

for repo in $(echo $repos | jq -r '.[] | .nameWithOwner'); do
    echo $repo:

    hooks=$(gh api \
        -H 'Accept: application/vnd.github+json' \
        -H 'X-GitHub-Api-Version: 2022-11-28' \
        /repos/$repo/hooks)

    present=false
    for hook in $(echo $hooks | jq -r '.[] | .config.url'); do
        if [[ $hook == $WEBHOOK ]]; then
            present=true
        fi
    done

    if [[ $present == false ]]; then
        curl -s -L \
            -X POST \
            -H 'Accept: application/vnd.github+json' \
            -H 'X-GitHub-Api-Version: 2022-11-28' \
            -H "Authorization: Bearer $TOKEN" \
            https://api.github.com/repos/$repo/hooks \
            -d "{\"name\":\"web\",\"active\":true,\"events\":[\"*\"],\"config\":{\"url\":\"$WEBHOOK\",\"content_type\":\"json\",\"insecure_ssl\":\"0\"}}" >/dev/null
    fi

    # DEBUG: /repos/$repo/hooks --jq '.[] | {url: .config.url, events: .events.[], created_at: .created_at, status: .last_response.status}'
    gh api \
        -H 'Accept: application/vnd.github+json' \
        -H 'X-GitHub-Api-Version: 2022-11-28' \
        /repos/$repo/hooks --jq '.[] | {events: .events.[], created_at: .created_at, status: .last_response.status}'
done
