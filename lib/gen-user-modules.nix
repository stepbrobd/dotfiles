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
        # index
        inputs.index.hmModules.nix-index
        # secret management
        # inputs.agenix.homeManagerModules.age
        # ({ config, ... }: with config.xdg; {
        #   # agenix #300
        #   age.secretsDir = "${stateHome}/agenix";
        #   age.secretsMountPoint = "${stateHome}/agenix.d";
        # })
        # inputs.sops.homeManagerModules.sops
        # state version
        { home = { inherit stateVersion; }; }
        # actual user module
        "${inputs.self}/users/${u}/home.nix"
      ] ++ (users.${u});
    });
  }
]
