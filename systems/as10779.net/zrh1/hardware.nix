{ config
, lib
, pkgs
, modulesPath
, ...
}:

{
  imports = [
    ./disko.nix
    "${modulesPath}/virtualisation/google-compute-image.nix"
  ];
}
