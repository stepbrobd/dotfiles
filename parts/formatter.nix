{
  perSystem = { lib, pkgs, ... }: {
    formatter = pkgs.writeShellScriptBin "formatter" ''
      ${lib.getExe pkgs.deno} fmt .
      ${lib.getExe pkgs.nixpkgs-fmt} .
    '';
  };
}
