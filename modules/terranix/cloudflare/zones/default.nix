{ lib, ... } @ args:

{ ... }:

let
  inherit (lib) map filter flatten attrNames readDir;
in
{
  imports = flatten (map
    (f: [
      (import ./${f}/dns.nix args)
    ])
    (filter
      (f: f != "default.nix")
      (attrNames (readDir ./.))));
}
