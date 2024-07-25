{ lib, inputs, ... }:

let
  inherit (lib) genAttrs mkSystem;

  darwinConfigFor = host: mkSystem {
    inherit inputs;
    systemType = "darwin";
    hostPlatform = "aarch64-darwin";
    systemStateVersion = 4;
    hmStateVersion = "24.11";
    systemConfig = ../../hosts/laptop/. + "/${host}";
    username = "ysun";
    extraModules = with inputs.self; [ darwinModules.common darwinModules.default ];
    extraHMModules = with inputs.self; [ hmModules.ysun.darwin ];
  };
in
{
  flake.darwinConfigurations = genAttrs [
    "macbook" # MacBook Pro 14-inch, Apple M2 Max, 64GB RAM, 1TB Storage
  ]
    (x: darwinConfigFor x);
}
