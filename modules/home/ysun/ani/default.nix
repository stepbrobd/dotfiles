{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "ani";
      text = ''exec ani-cli "$@"'';
      runtimeInputs = [
        aria2
        curlHTTP3
        ffmpeg
        fzf
        git
        gnugrep
        yt-dlp
      ]
      ++ lib.optional stdenv.isDarwin (ani-cli.override { withMpv = false; withVlc = false; withIina = true; })
      ++ lib.optional stdenv.isLinux (ani-cli.override { withMpv = true; withVlc = false; withIina = false; });
    })
  ];
}
