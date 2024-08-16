{
  perSystem = { pkgs, inputs', self', ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        inputs'.agenix.packages.agenix
        inputs'.colmena.packages.colmena
        self'.packages.stepbrobd

        direnv
        git
        nix-direnv
      ];
    };
  };
}
