{
  perSystem = { pkgs, inputs', self', ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        self'.packages.stepbrobd

        inputs'.colmena.packages.colmena
        inputs'.sops.packages.default

        cf-terraforming
        direnv
        git
        nix-direnv
        sops
        terraform
        terraformer
        terranix
      ];
    };
  };
}
