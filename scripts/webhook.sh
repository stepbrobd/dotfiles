#!/usr/bin/env zsh

set -eo pipefail

GITHUB_TOKEN=$TOKEN
WEBHOOK=$URL

repos=$(gh repo list stepbrobd --limit 1000 --json nameWithOwner)

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
    curl -L \
      -X POST \
      -H 'Accept: application/vnd.github+json' \
      -H 'X-GitHub-Api-Version: 2022-11-28' \
      -H "Authorization: Bearer $GITHUB_TOKEN" \
      https://api.github.com/repos/$repo/hooks \
      -d "{\"name\":\"web\",\"active\":true,\"events\":[\"*\"],\"config\":{\"url\":\"$WEBHOOK\",\"content_type\":\"json\",\"insecure_ssl\":\"0\"}}"
  fi

  # DEBUG: /repos/$repo/hooks --jq '.[] | {url: .config.url, events: .events.[], created_at: .created_at, status: .last_response.status}'
  gh api \
    -H 'Accept: application/vnd.github+json' \
    -H 'X-GitHub-Api-Version: 2022-11-28' \
    /repos/$repo/hooks --jq '.[] | {events: .events.[], created_at: .created_at, status: .last_response.status}'

done
