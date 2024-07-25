# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-configtool
      # ja
      fcitx5-mozc
      # zh
      fcitx5-rime
      rime-data
    ];
  };
}
