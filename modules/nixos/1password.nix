# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  programs = {
    _1password.enable = true;
    _1password-gui.enable = true;
    # seahorse.enable = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;

  services = {
    dbus.packages = with pkgs; [ gcr ];
    gnome.gnome-keyring.enable = true;
  };
}
