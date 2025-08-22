{
  terraform.required_providers.cloudflare.source = "cloudflare/cloudflare";
  provider.cloudflare = {
    email = ''''${data.sops_file.secrets.data["cloudflare.email"]}'';
    api_key = ''''${data.sops_file.secrets.data["cloudflare.api_key"]}'';
  };

  terraform.required_providers.sops.source = "carlpett/sops";
  provider.sops = { };
  data.sops_file.secrets.source_file = builtins.toString ../../../lib/secrets.yaml;
}
