# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.chromium = {
    enable = false; # use firefox

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
      # { id = "bgnkhhnnamicmpeenaelnjfhikgbkllg"; } # AdGuard
      # { id = "mljepckcnbghmcdmaebjhejiplcngbkm"; } # Hide Scrollbar
      # { id = "cdglnehniifkbagbbombnjghhcihifij"; } # Kagi
      # { id = "pejdijmoenmkgeppbflobdenhhabjlaj"; } # iCloud
      # { id = "ingkkggaggkbgnejpbblmbpodgmiojbo"; } # Mimi
      # { id = "nmgcefdhjpjefhgcpocffdlibknajbmj"; } # MyMind
      # { id = "honjmojpikfebagfakclmgbcchedenbo"; } # Nord
    ];
  };
}
