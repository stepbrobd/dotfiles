{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    pyproject = {
      url = "github:nix-community/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , utils
    , pyproject
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
          };
        };
        python = pkgs.python312;
      in
      {
        packages.default = python.pkgs.buildPythonPackage (
          pyproject.renderers.buildPythonPackage { inherit python; }
        );

        apps.default = utils.lib.mkApp { drv = self.packages.${system}.default; };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            direnv
            git
            nix-direnv
            ruff
          ];
          venvDir = "./.venv";
          buildInputs =
            [ python ]
            ++ (with python.pkgs; [
              venvShellHook
              setuptools
              wheel
            ]);
          shellHook = ''
            pip --disable-pip-version-check install -e .
          '';
        };

        formatter = pkgs.writeShellScriptBin "formatter" ''
          set -eoux pipefail
          ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt .
          ${pkgs.ruff}/bin/ruff check --fix --unsafe-fixes .
        '';
      }
    );
}
