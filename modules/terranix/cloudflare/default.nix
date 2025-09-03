{ lib, ... } @ args:

{ ... }:

let
  inherit (lib) map filter attrNames readDir;
  inherit (lib.terranix) acnsSettings;
in
{
  imports = map
    (f: import ./${f} args)
    (filter
      (f: f != "default.nix")
      (attrNames (readDir ./.)));

  resource.cloudflare_account_dns_settings.settings = acnsSettings;
}
