{ ... } @ args:

{
  flake.nixosModules = {
    caddy = import ../modules/nixos/caddy.nix;
    common = import ../modules/common;
    graphical = import ../modules/nixos/graphical.nix;
    minimal = import ../modules/nixos/minimal.nix;
  };
}
