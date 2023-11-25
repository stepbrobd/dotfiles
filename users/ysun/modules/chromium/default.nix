# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.chromium = {
    enable = true;

    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform,VaapiVideoDecoder"
      "--enable-accelerated-video-decode"
      "--enable-gpu-rasterization"
      "--enable-oop-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"
    ];

    extensions = [
      { id = "bgnkhhnnamicmpeenaelnjfhikgbkllg"; } # AdGuard
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "mljepckcnbghmcdmaebjhejiplcngbkm"; } # Hide Scrollbar
      { id = "cdglnehniifkbagbbombnjghhcihifij"; } # Kagi
      { id = "pejdijmoenmkgeppbflobdenhhabjlaj"; } # iCloud
      { id = "ingkkggaggkbgnejpbblmbpodgmiojbo"; } # Mimi
      { id = "nmgcefdhjpjefhgcpocffdlibknajbmj"; } # MyMind
      { id = "honjmojpikfebagfakclmgbcchedenbo"; } # Nord
    ];
  };
}
