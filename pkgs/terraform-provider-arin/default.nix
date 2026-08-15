{ terraform-providers }:

(terraform-providers.mkProvider {
  owner = "stepbrobd";
  repo = "terraform-provider-arin";
  rev = "v2026.815.0";
  hash = "sha256-cvsAFKHXXLOHs5QeVBH3aPqScEQI+tFAUEzRMkqWNAw=";
  vendorHash = "sha256-26uE3ef9C1pF3hvdPvm/UclewgMCQPhCjOyGtZWSFqE=";
  spdx = "MIT";
  provider-source-address = "registry.terraform.io/stepbrobd/arin";
}).overrideAttrs { subPackages = [ "cmd/terraform-provider-arin" ]; }
