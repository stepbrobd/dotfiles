{ lib, ... }:

let
  inherit (lib.terranix) tfRef;
  plausible = lib.blueprint.services.plausible.domain;
in
{
  resource.fastly_secretstore.howfastly = {
    name = "HowFastly";
  };

  resource.fastly_kvstore.howfastly = {
    name = "HowFastly";
    location = "EU";
  };

  resource.fastly_service_compute.howfastly = {
    name = "HowFastly";

    activate = false;

    product_enablement = [{
      name = "howfastly";
      domain_inspector = true;
      log_explorer_insights = true;
      # ddos_protection = [{
      #   enabled = true;
      #   mode = "log";
      # }];
    }];

    domain = [
      { name = "speed.edgecompute.app"; }
      { name = "howfastly.edgecompute.app"; }
    ];

    backend = [
      {
        name = "fastly";
        address = "api.fastly.com";
        port = 443;
        use_ssl = true;
        ssl_cert_hostname = "api.fastly.com";
        ssl_sni_hostname = "api.fastly.com";
        override_host = "api.fastly.com";
      }
      {
        name = "plausible";
        address = plausible;
        port = 443;
        use_ssl = true;
        ssl_cert_hostname = plausible;
        ssl_sni_hostname = plausible;
        override_host = plausible;
        # tracking is awaited after response
        # slow plausible must not hold finished instances
        connect_timeout = 1000;
        first_byte_timeout = 2000;
        between_bytes_timeout = 2000;
      }
    ];

    resource_link = [
      {
        name = "secretstore";
        resource_id = tfRef "fastly_secretstore.howfastly.id";
      }
      {
        name = "kvstore";
        resource_id = tfRef "fastly_kvstore.howfastly.id";
      }
    ];

    lifecycle.ignore_changes = [ "package" ];
  };
}
