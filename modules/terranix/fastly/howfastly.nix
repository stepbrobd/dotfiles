{ ... }:

{
  resource.fastly_service_compute.howfastly = {
    name = "speed.edgecompute.app";

    activate = false;

    domain = [
      { name = "speed.edgecompute.app"; }
      { name = "howfastly.edgecompute.app"; }
    ];

    lifecycle.ignore_changes = [ "package" ];
  };
}
