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
      pkgs = import nixpkgs { inherit system; };
    in
    {
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
    });
}
