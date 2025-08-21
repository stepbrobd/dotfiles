{ config, ... }:

let
  mode = "0400";
in
{
  sops.secrets."nix.conf/access-tokens" = { inherit mode; };
  sops.secrets."nix.conf/netrc-file" = { inherit mode; };

  nix = {
    settings.netrc-file = config.sops.secrets."nix.conf/netrc-file".path;
    extraOptions = "!include ${config.sops.secrets."nix.conf/access-tokens".path}";
  };
}
