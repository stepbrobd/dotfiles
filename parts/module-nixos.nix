{ ... } @ args:

{
  flake.nixosModules = {
    caddy = import ../modules/nixos/caddy.nix;
    common = import ../modules/common;
    desktop = import ../modules/nixos/desktop.nix;
    docker = import ../modules/nixos/docker.nix;
    graphical = import ../modules/nixos/graphical.nix;
    minimal = import ../modules/nixos/minimal.nix;
  };
}
