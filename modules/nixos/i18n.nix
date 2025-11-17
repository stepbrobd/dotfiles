{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc
      fcitx5-nord
      fcitx5-rime
      fcitx5-table-extra
      qt6Packages.fcitx5-configtool
      rime-data
    ];
  };
}
