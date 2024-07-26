{ inputs, ... }:

{
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        inputs.agenix.packages.${system}.agenix
        direnv
        git
        nix-direnv
      ];
    };
  };
}
