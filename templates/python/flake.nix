{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pyproject = {
      url = "github:nix-community/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , pyproject
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
        python3 = pkgs.python311;
      in
      {
        packages.default = python.pkgs.buildPythonPackage (
          project.renderers.buildPythonPackage { inherit python; }
        );

        apps.default = flake-utils.lib.mkApp { drv = self.packages.${system}.default; };

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
          ${pkgs.ruff}/bin/ruff --fix --unsafe-fixes .
        '';
      }
    );
}
