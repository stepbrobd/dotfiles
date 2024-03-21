{ ... } @ args:

{
  flake.nixosModules = {
    common = import ../modules/common;
    graphical = import ../modules/nixos/graphical.nix;
    minimal = import ../modules/nixos/minimal.nix;
  };
}
