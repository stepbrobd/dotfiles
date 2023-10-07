{ config
, lib
, pkgs
, ...
}:

{
  home.stateVersion = "23.11";

  home = {
    username = "ysun";
    homeDirectory =
      if pkgs.stdenv.isLinux
      then "/home/ysun"
      else if pkgs.stdenv.isDarwin
      then "/Users/ysun"
      else abort "Unsupported OS";
  };
}
