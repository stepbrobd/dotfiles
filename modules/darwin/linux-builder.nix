{
  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    maxJobs = 8;
    systems = [ "x86_64-linux" ];
  };
}
