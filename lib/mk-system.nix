{ lib }:

# mkSystem args
{ inputs
, os
, hostPlatform
, systemStateVersion
, hmStateVersion
, systemConfig
, username
, extraModules ? [ ]
, extraHMModules ? [ ]
, overlays ? [ ]
}:

lib."${os}System" {
  specialArgs = { inherit inputs; };

  modules = [
    # system
    systemConfig
    # agenix
    inputs.agenix."${os}Modules".age
    # home-manager
    (../. + "/users/${username}")
    inputs.hm."${os}Modules".home-manager
    {
      home-manager.extraSpecialArgs = {
        inherit inputs;
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
    { nixpkgs.overlays = overlays ++ [ inputs.self.overlays.default ]; }
  ] ++ extraModules;
}
