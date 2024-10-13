{ pkgs, ... }:

{
  services.portunus = {
    enable = true;
    domain = "ldap.ysun.co";
    port = 18080;
    dex.enable = false; # use keycloak instead
    ldap = {
      suffix = "dc=ysun,dc=co";
      # tls = true;
    };
    seedSettings = {
      groups = [
        {
          name = "ldap-admin";
          long_name = "Portunus LDAP Admin Group";
          members = [ "ysun" ];
          permissions.portunus.is_admin = true;
        }
        {
          name = "ldap-search";
          long_name = "Portunus LDAP Search Group";
          members = [ "search" ];
          permissions.ldap.can_read = true;
        }
      ];
      users = [
        {
          login_name = "search";
          given_name = "Search";
          family_name = "LDAP";
          password.from_command = [
            "${pkgs.coreutils}/bin/cat"
            config.sops.secrets."portunus/search-password".path
          ];
        }
        {
          login_name = "ysun";
          given_name = "Yifei";
          family_name = "Sun";
          password.from_command = [
            "${pkgs.coreutils}/bin/cat"
            config.sops.secrets."portunus/admin-password".path
          ];
        }
      ];
    };
  };
}
