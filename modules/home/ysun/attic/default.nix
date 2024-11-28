# { inputs, ... }:

# { config, pkgs, ... }:

{ pkgs, ... }:

{
  home.packages = [ pkgs.attic-client ];

  # age.secrets.attic.file = "${inputs.self.outPath}/secrets/attic-client.toml.age";
  # home.file."${config.xdg.configHome}/attic/config.toml".source = config.age.secrets.attic.path;
}
