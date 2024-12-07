{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "ani";
      text = "exec ani-cli";
      runtimeInputs = [
        ani-cli
        aria2
        curl
        ffmpeg
        fzf
        git
        gnugrep
        yt-dlp
      ]
      ++ lib.optional stdenv.isDarwin iina
      ++ lib.optional stdenv.isLinux mpv;
    })
  ];
}
