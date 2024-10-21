{ pkgs, ... }:

# archived, see kanidm
{
  services.keycloak = {
    enable = false;

    settings = {
      http-enabled = true;
      http-host = "127.0.0.1";
      http-port = 8080;
      hostname = "auth.ysun.co";
      proxy-headers = "xforwarded";
      cache = "local";
    };
    database.passwordFile = toString (pkgs.writeText "password" "keycloak");
  };
}
