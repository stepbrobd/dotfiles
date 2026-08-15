{ lib, ... } @ args:

{ ... }:

let
  inherit (lib) attrNames concatMap deepMergeAttrsList filter map readDir;
  inherit (lib.terranix) mkZoneSettingResources;

  zones = filter (f: f != "default.nix") (attrNames (readDir ./.));
in
{
  imports = concatMap
    (f: [
      (import ./${f}/dns.nix args)
      (import ./${f}/zone.nix args)
    ])
    zones;

  # common zone settings applied unconditionally
  resource.cloudflare_zone_setting = deepMergeAttrsList (map mkZoneSettingResources zones);
}
