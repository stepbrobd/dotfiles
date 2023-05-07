{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    home = {
      activation = {
        dotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          #!/usr/bin/env nix-shell
          #!nix-shell -i zsh -p curl git perl smimesign
          set -eo pipefail
          export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" && PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
          curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/stepbrobd/dotfiles/master/scripts/setup.sh | zsh
        '';
      };
    };
  };
}
