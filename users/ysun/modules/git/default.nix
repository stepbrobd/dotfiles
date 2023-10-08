{ config
, lib
, pkgs
, ...
}:

{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Yifei Sun";
    userEmail = "ysun+git@stepbrobd.com";
  };
}
