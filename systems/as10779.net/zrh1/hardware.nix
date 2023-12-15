{ config
, lib
, pkgs
, modulesPath
, ...
}:

{
  imports = [
    "${modulesPath}/virtualisation/google-compute-image.nix"
  ];
}
