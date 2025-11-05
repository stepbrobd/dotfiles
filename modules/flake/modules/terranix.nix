{ config, lib, modulesFor, ... }:

{
  flake.terranixModules = modulesFor "terranix";

  perSystem = { pkgs, self', system, ... }: {
    packages.terranixConfiguration =
      let
        inherit system;
        modules = lib.attrValues config.flake.terranixModules;
      in
      (lib.terranixConfiguration {
        inherit system modules;
      }).overrideAttrs (_: {
        passthru = {
          inherit (lib.terranixConfigurationAst {
            inherit system modules;
          }) config;
        };
      });

    apps.terranix =
      let
        tf = (pkgs.opentofu.withPlugins (p: with p; [ cloudflare_cloudflare carlpett_sops tailscale_tailscale ]));
      in
      {
        type = "app";
        program = toString (pkgs.writers.writeBash "apply" ''
          rm -f config.tf.json
          $(${lib.getExe pkgs.sops} decrypt --extract '["cloudflare"]["backend"]["export"]' ${../../../lib/terranix/secrets.yaml})
          cp ${self'.packages.terranixConfiguration} config.tf.json \
            && ${lib.getExe tf} init \
            && ${lib.getExe tf} apply -auto-approve
          rm -f config.tf.json
        '');
      };
  };
}
