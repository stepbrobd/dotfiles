{ lib, ... }:

let
  inherit (lib.terranix) tfRef;
in
{
  resource.fastly_secretstore.howfastly = {
    name = "HowFastly";
  };

  resource.fastly_service_compute.howfastly = {
    name = "HowFastly";

    activate = false;

    domain = [
      { name = "speed.edgecompute.app"; }
      { name = "howfastly.edgecompute.app"; }
    ];

    backend = [{
      name = "fastly";
      address = "api.fastly.com";
      port = 443;
      use_ssl = true;
      ssl_cert_hostname = "api.fastly.com";
      ssl_sni_hostname = "api.fastly.com";
      override_host = "api.fastly.com";
    }];

    resource_link = [{
      name = "howfastly";
      resource_id = tfRef "fastly_secretstore.howfastly.id";
    }];

    lifecycle.ignore_changes = [ "package" ];
  };
}
