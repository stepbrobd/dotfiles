# https://github.com/nix-community/nixvim

{ stdenv
, lib
, inputs
}:

let
  nixvim = inputs.nixvim.legacyPackages."${stdenv.system}";
  inherit (lib) attrNames map readDir;
in
lib.makeOverridable nixvim.makeNixvimWithModule {
  module.imports = map (x: ./plugins/. + "/${x}") (attrNames (readDir ./plugins));
}
