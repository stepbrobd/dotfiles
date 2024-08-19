{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Yifei Sun";
    userEmail = "ysun@hey.com";
    signing = {
      signByDefault = true;
      key = "D973170F9B86DB70";
    };

    # colored diff tool
    difftastic.enable = true;

    extraConfig = {
      branch.sort = "-committerdate";
      color.ui = true;
      column.ui = "auto";
      core.autocrlf = "input";
      core.fsmonitor = true;
      core.sshCommand = "ssh -o TCPKeepAlive=yes -o ServerAliveInterval=60";
      core.untrackedcache = true;
      fetch.writeCommitGraph = true;
      filter.lfs.clean = "git-lfs clean -- %f";
      filter.lfs.smudge = "git-lfs smudge -- %f";
      init.defaultBranch = "master";
      merge.conflictstyle = "diff3";
      push.autoSetupRemote = true;
      push.default = "upstream";
      pull.ff = "only";
      pull.rebase = false;
      submodule.recurse = true;
    };
  };
}
