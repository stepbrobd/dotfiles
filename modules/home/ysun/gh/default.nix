# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
    extensions = with pkgs; [
      gh-copilot
      gh-dash
      gh-eco
      gh-f
    ];
  };
}
