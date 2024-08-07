{ modulesFor, ... }:

{
  flake = rec {
    hmModules = homeManagerModules;

    homeManagerModules = {
      ysun = {
        darwin = import ../../modules/home/ysun/darwin.nix;
        graphical = import ../../modules/home/ysun/graphical.nix;
        linux = import ../../modules/home/ysun/linux.nix;
        minimal = import ../../modules/home/ysun/minimal.nix;
      };
    };
  };
}
