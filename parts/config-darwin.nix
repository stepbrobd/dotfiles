{ ... } @ args:

let
  inherit (args) inputs outputs;
  inherit (outputs.lib) genAttrs mkSystem;

  darwinConfigFor = host: mkSystem {
    systemType = "darwin";
    hostPlatform = "aarch64-darwin";
    systemStateVersion = 4;
    hmStateVersion = "24.11";
    systemConfig = ../systems/darwin/. + "/${host}";
    username = "ysun";
    extraModules = [ outputs.darwinModules.common outputs.darwinModules.default ];
    extraHMModules = [ outputs.hmModules.ysun.darwin ];
  };
in
{
  flake.darwinConfigurations = genAttrs [
    "macbook" # MacBook Pro 14-inch, Apple M2 Max, 64GB RAM, 1TB Storage
  ]
    (x: darwinConfigFor x);
}
