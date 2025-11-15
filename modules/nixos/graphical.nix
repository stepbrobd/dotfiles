{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    audio
    desktop
    fonts
    i18n
    one-password
    tailscale
    mglru
  ];
}
