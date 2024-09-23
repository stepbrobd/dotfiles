{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    desktop
    fonts
    i18n
    one-password
    tailscale
  ];
}
