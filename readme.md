# Dotfiles

Dotfiles with pseudo-idempotent setup script, repository should be in `~/.config/dotfiles` directory.

## Setup

1. [Home Manager](https://github.com/nix-community/home-manager): [`home.activation`](https://rycee.gitlab.io/home-manager/options.html#opt-home.activation):

```nix
{
  dotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i zsh -p curl git perl smimesign
    set -eo pipefail
    export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" && PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
    curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/stepbrobd/dotfiles/master/scripts/setup.sh | zsh
  '';
}
```

2. Standalone:

```shell
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/stepbrobd/dotfiles/master/scripts/setup.sh | zsh
```

## License

This repository content excluding all submodules is licensed under the [WTFPL License](LICENSE.md), third-party code are subject to their original license.
