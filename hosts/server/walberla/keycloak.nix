{ pkgs, ... }:

{
  services.keycloak = {
    enable = true;
    settings = {
      http-host = "127.0.0.1";
      http-port = 8080;
      proxy = "edge";
      hostname = "id.ysun.co";
      cache = "local";
    };
    database.passwordFile = toString (pkgs.writeText "password" "keycloak");
  };
}
