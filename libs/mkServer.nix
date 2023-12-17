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
, extraModules
}:

lib."${systemType}System" {
  specialArgs = { inherit inputs outputs; };
  modules = [
    ../modules/nix
    ../modules/nixpkgs
    systemConfig
    inputs.agenix."${systemType}Modules".age
    (../. + "/users/${username}")
    { nixpkgs.hostPlatform = lib.mkDefault hostPlatform; }
    { system.stateVersion = stateVersion; }
    { system.configurationRevision = rev; }
  ] ++ extraModules;
}
