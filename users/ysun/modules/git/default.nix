# home-manager options

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
    signing = {
      signByDefault = true;
      key = null;
    };
    extraConfig = {
      color.ui = true;
      core.autocrlf = "input";
      core.sshCommand = "ssh -o TCPKeepAlive=yes -o ServerAliveInterval=60";
      filter.lfs.clean = "git-lfs clean -- %f";
      filter.lfs.smudge = "git-lfs smudge -- %f";
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
      push.default = "upstream";
      pull.ff = "only";
      pull.rebase = false;
      submodule.recurse = true;
    };
  };
}
