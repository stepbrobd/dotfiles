{
  perSystem = { lib, pkgs, ... }: {
    formatter = pkgs.writeShellScriptBin "formatter" ''
      pushd "$(${lib.getExe pkgs.git} rev-parse --show-toplevel)" > /dev/null
      set -eoux pipefail
      shopt -s globstar

      ${lib.getExe pkgs.actionlint} -color
      ${lib.getExe pkgs.deno} fmt .
      ${lib.getExe pkgs.gitleaks} git --no-banner --pre-commit --staged
      ${lib.getExe pkgs.nixpkgs-fmt} .
      ${lib.getExe pkgs.taplo} format **/*.toml
      ${lib.getExe pkgs.zizmor} --fix=all .

      popd
    '';
  };
}
