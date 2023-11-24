{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
      lib = pkgs.lib;
      python3 = pkgs.python311;

      python3Env = (python3.withPackages (ps: with ps; [
      ])).override (args: { ignoreCollisions = true; });

      drv = python3.pkgs.buildPythonPackage {
        pname = "<NAME>";
        inherit ((lib.importTOML ./pyproject.toml).project) version;
        pyproject = true;
        enableParallelBuilding = true;
        src = lib.cleanSource ./.;
        propagatedBuildInputs = [ python3Env ];
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
          direnv
          git
          nix-direnv
          ruff
        ];

        buildInputs = [ python3Env ];

        shellHook = ''
          export "VENV=.venv"

          if [ ! -d "$VENV" ]; then
            virtualenv "$VENV"
          fi

          source "$VENV/bin/activate"
          export "PYTHONPATH=$PWD/$VENV/${python3.sitePackages}/:$PYTHONPATH"
          pip install --upgrade pip
          pip install --editable .
        '';
      };
    });
}
