# nixpkgs module, import directly to system settings

{ config
, lib
, pkgs
, ...
}:

{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config = {
      init.defaultBranch = "master";
      core.autocrlf = "input";
      pull.rebase = "true";
      pull.autoSetupRemote = "true";
      push.autoSetupRemote = "true";
      submodule.recurse = "true";
      lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = "true";
      };
    };
  };
}
