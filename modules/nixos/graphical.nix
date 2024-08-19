{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    ./1password.nix
    desktop
    fonts
    i18n
    tailscale
  ];
}
