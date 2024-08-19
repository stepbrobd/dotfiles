{ modulesFor, ... }:

{
  flake = rec {
    hmModules = homeManagerModules;

    homeManagerModules = {
      ysun = modulesFor "home/ysun";
    };
  };
}
