{ lib }:

{ hosts
, inputs
, systemType
, hostPlatform
, systemStateVersion
, hmStateVersion
, username
, extraModules ? [ ]
, extraHMModules ? [ ]
, config ? { }
, overlays ? [ ]
}:

{
  meta = {
    nixpkgs = import inputs.nixpkgs { inherit config overlays; system = hostPlatform; };
    specialArgs = { inherit inputs; };
  };
} // lib.genAttrs hosts (host: {
  imports = [
    # system
    (inputs.self.outPath + "/hosts/server/${host}")
    # agenix
    inputs.agenix."${systemType}Modules".age
    # home-manager
    (inputs.self.outPath + "/users/${username}")
    inputs.hm."${systemType}Modules".home-manager
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
  ] ++ extraModules;
})
