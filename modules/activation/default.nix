# nixpkgs + nix-darwin options: https://github.com/numtide/srvos/blob/main/nixos/common/upgrade-diff.nix
# don't add this module if SrvOS is used

{ config
, lib
, pkgs
, ...
}:

{
  system.activationScripts = {
    diff.text = ''
      if [[ -e /run/current-system ]]; then
        echo "--- diff to current-system"
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
        echo "---"
      fi
    '';
  };
}
