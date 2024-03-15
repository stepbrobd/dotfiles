# nixpkgs + nix-darwin options: https://github.com/numtide/srvos/blob/main/nixos/common/upgrade-diff.nix
# don't add this module if SrvOS is used

{ config
, lib
, pkgs
, ...
}:

{
  system.activationScripts =
    {
      diff.text = ''
        if [[ -e /run/current-system ]]; then
          echo "--- diff to current-system"
          ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
          echo "---"
        fi
      '';
    }
    // lib.optionalAttrs pkgs.stdenv.isDarwin {
      extraActivation.text = ''
        if [[ "$(systemsetup -getremotelogin | sed 's/Remote Login: //')" == "Off" ]]; then
          launchctl load -w /System/Library/LaunchDaemons/ssh.plist
        fi
      '';
    };
}
