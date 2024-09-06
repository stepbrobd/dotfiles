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
        packages.default = pkgs.stdenvNoCC.mkDerivation {
          name = "<NAME>";
          version = self.shortRev or self.dirtyShortRev;
          src = ./.;
          nativeBuildInputs = [ pkgs.typst ];
          buildPhase = ''
            typst compile main.typ main.pdf
          '';
          installPhase = ''
            mv main.pdf $out
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            direnv
            git
            hayagriva
            nix-direnv
            typst
          ];
        };

        formatter = pkgs.writeShellScriptBin "formatter" ''
          set -eoux pipefail
          shopt -s globstar
          ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt .
          ${pkgs.typstfmt}/bin/typstfmt **/*.typ
        '';
      }
    );
}
