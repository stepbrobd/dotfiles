{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , utils
    , gomod2nix
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ gomod2nix.overlays.default ];
        };
      in
      {
        packages.default = pkgs.buildGoApplication {
          pname = "<NAME>";
          version = self.shortRev or self.dirtyShortRev;
          src = ./.;
          modules = ./gomod2nix.toml;
        };

        apps.default = utils.lib.mkApp { drv = self.packages.${system}.default; };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            delve
            go
            gopls
            gotools
            go-tools
            gomod2nix.packages.${system}.default
          ];
        };

        formatter = pkgs.writeShellScriptBin "formatter" ''
          set -eoux pipefail
          ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt .
          ${pkgs.go}/bin/gofmt -s -w .
        '';
      }
    );
}
