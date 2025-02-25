{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Yifei Sun";
    userEmail = "ysun@hey.com";

    # colored diff tool
    difftastic.enable = true;

    extraConfig = {
      # signing
      gpg.format = "ssh";
      commit.gpgsign = "true";
      user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519";

      # misc
      branch.sort = "-committerdate";
      color.ui = true;
      column.ui = "auto";
      commit.verbose = true;
      core.autocrlf = "input";
      core.fsmonitor = true;
      core.sshCommand = "ssh -o TCPKeepAlive=yes -o ServerAliveInterval=60";
      core.untrackedCache = true;
      core.untrackedcache = true;
      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = true;
      diff.renames = true;
      fetch.all = true;
      fetch.prune = true;
      fetch.pruneTags = true;
      fetch.writeCommitGraph = true;
      filter.lfs.clean = "git-lfs clean -- %f";
      filter.lfs.smudge = "git-lfs smudge -- %f";
      help.autocorrect = "prompt";
      init.defaultBranch = "master";
      merge.conflictstyle = "zdiff3";
      pull.rebase = true;
      push.autoSetupRemote = true;
      push.default = "upstream";
      push.followTags = true;
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = true;
      rerere.autoupdate = true;
      rerere.enabled = true;
      submodule.recurse = true;
      tag.sort = "version:refname";
    };
  };
}
