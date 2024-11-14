# https://github.com/nix-community/nixvim

{ stdenv
, lib
, inputs
}:

let
  nixvim = inputs.nixvim.legacyPackages."${stdenv.system}";
  inherit (lib) attrNames filter map readDir;
in
lib.makeOverridable nixvim.makeNixvimWithModule {
  module.imports = map
    (f: ./${f})
    (filter
      (f: f != "default.nix")
      (attrNames (readDir ./.)));
}
