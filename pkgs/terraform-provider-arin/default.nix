{ terraform-providers }:

(terraform-providers.mkProvider {
  owner = "stepbrobd";
  repo = "terraform-provider-arin";
  rev = "v2026.812.0";
  hash = "sha256-f2ec6UkglRLTUJPgWYMTExAjXezK4LXRv1du42Mvh6k=";
  vendorHash = "sha256-yjSn7MDYrBKI01BwRLfna2LA5HGuPSAfCq48O8fCLf4=";
  spdx = "MIT";
  provider-source-address = "registry.terraform.io/stepbrobd/arin";
}).overrideAttrs { subPackages = [ "cmd/terraform-provider-arin" ]; }
