# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      update_check = false;
      filter_mode = "global";
      search_mode = "fuzzy";
      sync_frequency = "24h";
      sync_address = "https://api.atuin.sh";
    };
  };
}
