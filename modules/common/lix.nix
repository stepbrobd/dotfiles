{ inputs, lib, ... }:

{ config, options, ... }:

let
  inherit (lib) mkOption mkIf types;

  cfg = config.nix.lix;
in
{
  options.nix.lix = {
    enable = mkOption {
      default = false;
      description = "Whether to replace Nix with Lix";
      example = true;
      type = types.bool;
    };
  };

  imports = [ inputs.lix-module.nixosModules.default ];

  config = mkIf cfg.enable {
    nix.settings = {
      extra-substituters = [ "https://cache.lix.systems" ];
      trusted-public-keys = [ "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" ];
    };
  };
}
