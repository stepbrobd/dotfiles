# haumea args
{ lib
, rev
, inputs
, outputs
}:

# mkServer args
{ systemType
, hostPlatform
, stateVersion
, systemConfig
, username
, extraModules ? [ ]
, overlays ? [ ]
}:

lib."${systemType}System" {
  specialArgs = { inherit inputs outputs; };
  modules = [
    ../modules/nix
    ../modules/nixpkgs
    systemConfig
    inputs.agenix."${systemType}Modules".age
    (../. + "/users/${username}")
    # platform
    { nixpkgs.hostPlatform = lib.mkDefault hostPlatform; }
    # state version
    { system.stateVersion = stateVersion; }
    { system.configurationRevision = rev; }
    # overlays
    { nixpkgs.overlays = overlays ++ [ outputs.overlays.default ]; }
  ] ++ extraModules;
}
