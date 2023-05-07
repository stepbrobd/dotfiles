{ inputs, ... }@context:
{ config, lib, pkgs, ... }: {
  config = {
    home = {
      packages = [
        pkgs.qemu
        pkgs.docker
        pkgs.terraform
        pkgs.awscli2
        pkgs.flyctl
        pkgs.ffmpeg
        pkgs.yt-dlp
        pkgs.texlive.combined.scheme-full
        pkgs.zathura
        pkgs.vscode
        pkgs.zoom-us
      ];
    };
  };
}
