# haumea args
{ inputs, outputs }:

# mkSystem args
{ systemType
, hostPlatform
, systemStateVersion
, hmStateVersion
, systemConfig
, username
, extraModules ? [ ]
, extraHMModules ? [ ]
, overlays ? [ ]
,
}:

let
  inherit (outputs) lib;
in
lib."${systemType}System" {
  specialArgs = {
    inherit inputs outputs;
  };

  modules = [
    # system
    systemConfig
    # agenix
    inputs.agenix."${systemType}Modules".age
    # home-manager
    (../. + "/users/${username}")
    inputs.hm."${systemType}Modules".home-manager
    {
      home-manager.extraSpecialArgs = {
        inherit inputs outputs;
      };
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = {
        imports = [
          (../. + "/users/${username}/home.nix")
          inputs.index.hmModules.nix-index
        ] ++ extraHMModules;
      };
    }
    # platform
    { nixpkgs.hostPlatform = lib.mkDefault hostPlatform; }
    # state version
    { system.stateVersion = systemStateVersion; }
    { home-manager.users."${username}".home.stateVersion = hmStateVersion; }
    # overlays
    { nixpkgs.overlays = overlays ++ [ outputs.overlays.default ]; }
    # not needed since useGlobalPkgs is set
    # { home-manager.users."${username}".nixpkgs.overlays = overlays ++ [ outputs.overlays.default ]; }
  ] ++ extraModules;
}
