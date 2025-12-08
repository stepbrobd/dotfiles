{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    audio
    desktop
    fonts
    i18n
    wayvnc
  ];
}
