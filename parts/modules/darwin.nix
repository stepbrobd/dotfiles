{ lib, inputs, ... }:

{
  flake.darwinModules = {
    common = lib.importApplyWithArgs ../../modules/common { inherit lib inputs; };
    lix = lib.importApplyWithArgs ../../modules/common/lix.nix { inherit lib inputs; };
    default = import ../../modules/darwin;
  };
}
