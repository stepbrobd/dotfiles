{ lib, ... }:

{
  # use podman
  virtualisation.docker.enable = lib.mkForce false;

  virtualisation.oci-containers.backend = "podman";
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
