{ pkgs, ... }:

{
  nix.linux-builder = {
    enable = true;
    ephemeral = true;

    maxJobs = 2;
    package = pkgs.darwin.linux-builder-x86_64;
    systems = [ "x86_64-linux" ];
  };
}
