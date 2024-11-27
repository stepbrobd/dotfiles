{ lib }:

{ inputs
, os
, stateVersion
, specialArgs ? { }
, users ? { } # { "username" -> [ module ] }
}:

let
  inherit (lib) attrNames genAttrs map;

  usernames = attrNames users;
in
map (u: "${inputs.self}/users/${u}") usernames ++ [
  inputs.hm."${os}Modules".home-manager
  {
    home-manager.extraSpecialArgs = specialArgs;
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users = genAttrs usernames (u: {
      imports = [
        inputs.index.hmModules.nix-index
        { home = { inherit stateVersion; }; }
        "${inputs.self}/users/${u}/home.nix"
      ] ++ (users.${u});
    });
  }
]
