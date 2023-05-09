{ config, lib, pkgs, ... }: {
  config = {
    home.activation = {
      dotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i zsh -p curl git perl smimesign

        set -eo pipefail

        export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" && PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
        curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/stepbrobd/dotfiles/master/scripts/setup.sh | zsh
      '';

      darwin = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
        let
          apps = pkgs.buildEnv {
            name = "home-manager-applications";
            paths = config.home.packages;
            pathsToLink = "/Applications";
          };
        in
        lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          #!/usr/bin/env nix-shell
          #!nix-shell -i zsh

          set -eo pipefail

          app_path="$HOME/Applications/Home Manager Apps"
          tmp_path="$(mktemp -dt "home-manager-apps.XXXXXXXXXX")" || exit 1

          for app in \
            $(find "${apps}/Applications" -maxdepth 1 -type l)
          do
            real_app="$(realpath "$app")"
            app_name="$(basename "$app")"
            $DRY_RUN_CMD ${inputs.mkalias.outputs.apps.${system}.default.program} "$real_app" "$tmp_path/$app_name"
          done

          $DRY_RUN_CMD rm -rf "$app_path"
          $DRY_RUN_CMD mv "$tmp_path" "$app_path"
        ''
      );
    };
  };
}
