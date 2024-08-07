{ common, moduleFor }:

{
  flake.darwinModules = common // {
    default = import ../../modules/darwin;
  };
}
