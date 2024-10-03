{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ { self, nixpkgs, parts }: parts.lib.mkFlake { inherit inputs; } {
    systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];

    perSystem = { pkgs, ... }: {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          direnv
          git
          nix-direnv
          tex-fmt
          texliveFull
        ];
      };

      formatter = pkgs.writeShellScriptBin "formatter" ''
        set -eoux pipefail
        shopt -s globstar
        ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt .
        ${pkgs.tex-fmt}/bin/tex-fmt **/*.tex
      '';
    };
  };
}
