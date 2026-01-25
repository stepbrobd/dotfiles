{ lib }:

{ inputs
, os
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
        # secrets
        inputs.sops.homeManagerModules.sops
        { sops.defaultSopsFile = ./secrets.yaml; }
        ({ config, ... }: { sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt"; })
        # actual user module
        "${inputs.self}/users/${u}/home.nix"
      ] ++ (users.${u});
    });
  }
]
