{ config
, lib
, pkgs
, modulesPath
, ...
}:

{
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
  ];
}
