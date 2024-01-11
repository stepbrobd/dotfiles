# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}
