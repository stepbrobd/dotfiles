{ inputs
, lib
, stdenv
, writeShellApplication
, opentofu
, sops
}:

let
  config = lib.terranixConfiguration {
    inherit (stdenv.hostPlatform) system;
    modules = lib.attrValues inputs.self.terranixModules;
  };

  terranixActionFor = action: writeShellApplication {
    name = "terranix";

    runtimeInputs = [
      opentofu # already overridden with required plugins
      sops # for secretes ofc
    ];

    # assuming SOPS_AGE_KEY_FILE is already set by the executing environment
    text = ''
      rm -f config.tf.json .terraform.lock.hcl

      cp ${config} config.tf.json

      AWS_ACCESS_KEY_ID="$(sops decrypt --extract '["cloudflare"]["backend"]["access_key"]' ${inputs.self}/lib/terranix/secrets.yaml)"
      AWS_SECRET_ACCESS_KEY="$(sops decrypt --extract '["cloudflare"]["backend"]["secret_key"]' ${inputs.self}/lib/terranix/secrets.yaml)"
      export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

      tofu init

    '' + action + ''

      rm -f config.tf.json .terraform.lock.hcl
    '';
  };
in
config.overrideAttrs (prev: {
  passthru = prev.passthru // {
    plan = terranixActionFor ''
      tofu plan
    '';

    apply = terranixActionFor ''
      tofu apply -auto-approve
    '';
  };
})
