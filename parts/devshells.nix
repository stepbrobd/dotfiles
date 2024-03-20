{ ... } @ args:

{
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        args.inputs.agenix.packages.${system}.agenix
        direnv
        git
        nixVersions.unstable
        nix-direnv
      ];
    };
  };
}
