{ common, modulesFor }:

{
  flake.nixosModules = common // {
    caddy = import ../../modules/nixos/caddy.nix;
    desktop = import ../../modules/nixos/desktop.nix;
    docker = import ../../modules/nixos/docker.nix;
    graphical = import ../../modules/nixos/graphical.nix;
    minimal = import ../../modules/nixos/minimal.nix;
  };
}
