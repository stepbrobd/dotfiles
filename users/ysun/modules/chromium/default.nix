# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.chromium = {
    enable = true;

    extensions = [
      # AdGuard
      { id = "bgnkhhnnamicmpeenaelnjfhikgbkllg"; }
      # Bitwarden
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      # Hide Scrollbar
      { id = "mljepckcnbghmcdmaebjhejiplcngbkm"; }
      # Kagi
      { id = "cdglnehniifkbagbbombnjghhcihifij"; }
      # iCloud
      { id = "pejdijmoenmkgeppbflobdenhhabjlaj"; }
      # Mimi
      { id = "ingkkggaggkbgnejpbblmbpodgmiojbo"; }
      # MyMind
      { id = "nmgcefdhjpjefhgcpocffdlibknajbmj"; }
      # Nord
      { id = "honjmojpikfebagfakclmgbcchedenbo"; }
    ];
  };
}
