{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    ,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
          };
        };
      in
      {
        devShells.default =
          let
            terraform = pkgs.terraform.withPlugins (
              p: with p; [
                cloudflare
                sops
              ]
            );
          in
          pkgs.mkShell {
            packages = with pkgs; [
              awscli2
              cf-terraforming
              terraform
            ];
          };
      }
    );
}
