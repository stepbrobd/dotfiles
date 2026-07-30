{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {
      scripts = with pkgs.mpvScripts; [ modernz thumbfast ];
    };
  };

  home.packages = with pkgs; [
    ffmpeg
    miruro
    yt-dlp
  ];
}
