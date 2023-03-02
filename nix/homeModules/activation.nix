{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    home = {
      activation = {
        dotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          #!/bin/zsh
          export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
          curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/StepBroBD/Dotfiles/master/setup.sh | zsh >/dev/null 2>&1
        '';
      };
    };
  };
}
