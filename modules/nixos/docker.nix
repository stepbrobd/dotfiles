{ lib, ... }:

{
  # use podman
  virtualisation.docker.enable = lib.mkForce false;

  virtualisation.oci-containers.backend = "podman";
  virtualisation.containers.enable = false;
  virtualisation = {
    podman = {
      enable = false;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
