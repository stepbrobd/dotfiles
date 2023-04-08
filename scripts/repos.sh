#!/bin/zsh

set -eo pipefail

if [[ $1 == "help" ]] || [[ $# != 1 ]]; then
    echo "Usage: repos [add|ls|rm]"
fi

# TODO
