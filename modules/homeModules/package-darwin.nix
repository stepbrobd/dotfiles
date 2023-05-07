{ inputs, ... }@context:
{ config, lib, pkgs, ... }: {
  config = {
    home = {
      packages = [
        pkgs.qemu
        pkgs.lima
        pkgs.colima
        pkgs.docker
        pkgs.terraform
        pkgs.smimesign
        pkgs.cocoapods
        pkgs.awscli2
        pkgs.flyctl
        pkgs.ffmpeg
        pkgs.yt-dlp
        pkgs.texlive.combined.scheme-full
        pkgs.zathura
        pkgs.iterm2
        pkgs.raycast
        pkgs.vscode
        pkgs.zoom-us
        pkgs.iina
        pkgs.osu-lazer-bin
      ];
    };
  };
}
