# https://github.com/nix-community/nixvim

{ stdenv
, lib
, inputs
, pkgs
}:

let
  nixvim = inputs.nixvim.legacyPackages."${stdenv.system}";
  inherit (lib) attrNames filter map readDir;
in
lib.makeOverridable nixvim.makeNixvimWithModule {
  inherit pkgs;

  extraSpecialArgs = {
    inherit inputs;
    lib = lib.extend inputs.nixvim.lib.overlay;
  };

  module.imports = map
    (f: ./${f})
    (filter
      (f: f != "default.nix")
      (attrNames (readDir ./.)));
}
