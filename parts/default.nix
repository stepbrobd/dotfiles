{ ... } @ args:

{
  imports = [
    ./devshells.nix
    ./formatter.nix
    ./hydrajobs.nix
    ./lib.nix
    ./overlays.nix
    ./packages.nix
    ./schemas.nix
    ./templates.nix

    ./config-darwin.nix
    ./config-nixos.nix
  ];
}
