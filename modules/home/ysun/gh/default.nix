{ pkgs, ... }:

{
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
    extensions = with pkgs; [
      gh-dash
      gh-eco
      gh-f
    ];
  };
}
