{ ... } @ args:

let
  inherit (args) inputs outputs;
  inherit (inputs) darwin haumea hm nixpkgs parts utils;
in
{
  flake.lib = darwin.lib // hm.lib // nixpkgs.lib // parts.lib // utils.lib // haumea.lib.load {
    src = ../lib;
    inputs = { inherit inputs outputs; };
  };
}
