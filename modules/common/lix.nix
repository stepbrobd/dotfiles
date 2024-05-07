# nixpkgs + nix-darwin options

{ config
, lib
, pkgs
, options
, inputs
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.nix.lix;
in
{
  imports = [ inputs.lix-module.nixosModules.default ];

  options.nix.lix = {
    enable = mkEnableOption "lix";
  };

  config = mkIf cfg.enable {
    nix.settings = {
      extra-substituters = [ "https://cache.lix.systems" ];
      trusted-public-keys = [ "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" ];
    };
  };
}
