{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , gomod2nix
    }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          gomod2nix.overlays.default
        ];
      };

      drv = pkgs.buildGoApplication {
        pname = "<NAME>";
        version = self.shortRev or self.dirtyShortRev;
        src = ./.;
        modules = ./gomod2nix.toml;
      };
    in
    {
      formatter = pkgs.nixpkgs-fmt;

      packages = rec {
        <NAME> = drv;
        default = <NAME>;
      };

      apps = rec {
        <NAME> = flake-utils.lib.mkApp { drv = self.packages.${system}.<NAME>; };
        default = <NAME>;
      };

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
    });
}
