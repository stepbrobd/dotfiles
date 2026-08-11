let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  node = lock.nodes.root.inputs.compat;
  flake = (import
    (fetchTarball {
      url = "https://github.com/nixos/flake-compat/archive/${lock.nodes.${node}.locked.rev}.tar.gz";
      sha256 = lock.nodes.${node}.locked.narHash;
    })
    { src = ./.; }).outputs;
in
{ outputs = flake; } // flake.legacyPackages.${builtins.currentSystem}
