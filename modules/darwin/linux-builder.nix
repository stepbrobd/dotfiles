{
  nix.linux-builder = {
    enable = true;
    maxJobs = 2;
    systems = [ "x86_64-linux" ];
  };
}
