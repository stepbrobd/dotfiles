{ config
, lib
, pkgs
, modulesPath
, ...
}:

{
  imports = [
    "${modulesPath}/virtualisation/google-compute-config.nix"
  ];

  boot.blacklistedKernelModules = [ "i2c_piix4" ];
}
