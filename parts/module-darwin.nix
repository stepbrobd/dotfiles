{ ... } @ args:

{
  flake.darwinModules = {
    common = import ../modules/common;
    default = import ../modules/darwin;
  };
}
