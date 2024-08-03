{ lib, inputs, ... }:

{ config, pkgs, options, ... }:

let
  inherit (lib) mkOption mkIf optional types;

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

  config = mkIf cfg.enable {
    # FIXME: optional import will not work
    # _module.args.modules = [ inputs.lix-module.nixosModules.default ];

    nix.settings = {
      extra-substituters = [ "https://cache.lix.systems" ];
      trusted-public-keys = [ "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" ];
    };
  };
}
