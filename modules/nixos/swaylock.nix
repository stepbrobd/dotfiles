# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  security.pam.services.swaylock = { };
}
