{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , utils
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "<NAME>";
          inherit ((pkgs.lib.importTOML ./Cargo.toml).package) version;
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };

        apps.default = utils.lib.mkApp { drv = self.packages.${system}.default; };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            cargo
            rustc
            rustfmt
          ];
        };

        formatter = pkgs.writeShellScriptBin "formatter" ''
          set -eoux pipefail
          shopt -s globstar
          ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt .
          ${pkgs.rustfmt}/bin/rustfmt **/*.rs
        '';
      }
    );
}
