# nixpkgs + nix-darwin options

{ config
, lib
, pkgs
, options
, inputs
, ...
}:

let
  inherit (lib) forEach mkEnableOption mkIf mkMerge mkOption optionalAttrs types;

  cfg = config.nix.lix;
in
{
  options.nix.lix = {
    enable = mkEnableOption "lix";
  };

  config = mkIf cfg.enable {
    imports = [ inputs.lix-module.nixosModules.default ];
    nix = {
      extra-substituters = [ "https://cache.lix.systems" ];
      trusted-public-keys = [ "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" ];
    };
  };
};
