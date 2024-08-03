{ lib, inputs, ... }:

{
  flake.nixosModules = {
    caddy = import ../../modules/nixos/caddy.nix;
    common = lib.importApplyWithArgs ../../modules/common { inherit lib inputs; };
    desktop = import ../../modules/nixos/desktop.nix;
    docker = import ../../modules/nixos/docker.nix;
    graphical = import ../../modules/nixos/graphical.nix;
    lix = lib.importApplyWithArgs ../../modules/common/lix.nix { inherit lib inputs; };
    minimal = import ../../modules/nixos/minimal.nix;
  };
}
