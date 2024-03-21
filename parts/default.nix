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

    ./module-darwin.nix
    ./module-home.nix
    ./module-nixos.nix

    ./config-darwin.nix
    ./config-nixos.nix
  ];
}
