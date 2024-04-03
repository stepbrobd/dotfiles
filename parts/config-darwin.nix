{ ... } @ args:

let
  inherit (args) inputs outputs;
  inherit (outputs.lib) listToAttrs mkSystem;

  darwinConfigFor = host: platform: mkSystem {
    systemType = "darwin";
    hostPlatform = platform;
    systemStateVersion = 4;
    hmStateVersion = "24.05";
    systemConfig = ../systems/darwin/. + "/${host}";
    username = "ysun";
    extraModules = [ outputs.darwinModules.common outputs.darwinModules.default ];
    extraHMModules = [ outputs.hmModules.ysun.darwin ];
  };
in
{
  flake.darwinConfigurations = listToAttrs (map
    (attr: {
      name = attr.host;
      value = darwinConfigFor attr.host attr.platform;
    }) [
    # MacBook Pro 14-inch, Apple M2 Max, 64GB RAM, 1TB Storage
    { host = "mbp-14"; platform = "aarch64-darwin"; }
  ]);
}
