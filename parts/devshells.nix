{
  perSystem = { pkgs, inputs', self', ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        self'.packages.stepbrobd

        inputs'.colmena.packages.colmena
        inputs'.sops.packages.default

        direnv
        git
        nix-direnv
        sops
      ];
    };
  };
}
