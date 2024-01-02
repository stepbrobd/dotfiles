# nixpkgs options, host specific

{ config
, lib
, pkgs
, ...
}:

{
  services.soft-serve = {
    enable = true;
    settings = { };
  };
}
