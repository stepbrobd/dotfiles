{
  perSystem = { pkgs, inputs', ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        inputs'.agenix.packages.agenix
        inputs'.colmena.packages.colmena
        direnv
        git
        nix-direnv
      ];
    };
  };
}
