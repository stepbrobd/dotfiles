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

        inputs'.terranix.packages.default
        (opentofu.withPlugins (p: with p; [ cloudflare_cloudflare carlpett_sops tailscale_tailscale ]))
      ];
    };
  };
}
