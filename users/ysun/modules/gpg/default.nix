# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    mutableKeys = true;
    mutableTrust = true;
    publicKeys = [
      { source = ./pgp.asc; trust = "ultimate"; }
    ];
  };

  services.gpg-agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "tty";
  };
}
