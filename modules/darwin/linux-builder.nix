{ pkgs, ... }:

{
  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 8;
  };
}
