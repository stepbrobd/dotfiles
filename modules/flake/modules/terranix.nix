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

    apps.terranix = {
      type = "app";
      program = pkgs.writeShellApplication {
        name = "terranix";

        runtimeInputs = with pkgs; [
          sops
          (opentofu.withPlugins (_: with _; [ cloudflare_cloudflare carlpett_sops tailscale_tailscale ]))
        ];

        text = ''
          rm -f config.tf.json .terraform.lock.hcl

          if [[ -v GARNIX_CI ]]; then 
            export SOPS_AGE_KEY_FILE="$GARNIX_ACTION_PRIVATE_KEY_FILE"
          fi
          eval "$(sops decrypt --extract '["cloudflare"]["backend"]["export"]' ${../../../lib/terranix/secrets.yaml})"

          cp ${self'.packages.terranixConfiguration} config.tf.json

          tofu init
          tofu apply -auto-approve

          rm -f config.tf.json .terraform.lock.hcl
        '';
      };
    };
  };
}
