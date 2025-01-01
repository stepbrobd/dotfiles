# { config, pkgs, ... }:

{ pkgs, ... }:

{
  home.packages = [ pkgs.attic-client ];

  # sops.secrets.attic = { };

  # home.file."${config.xdg.configHome}/attic/config.toml".source = config.sops.secrets.attic.path;
}
