{ config, inputs, pkgs, ... }:

{
  services.caddy = {
    enable = true;

    virtualHosts."hydra.ysun.co".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.hydra.listenHost}:${toString config.services.hydra.port}
    '';
  };

  sops.secrets.hydra = {
    owner = "hydra";
    group = "hydra";
    mode = "440";
  };

  services.hydra = {
    enable = true;
    logo = ./logo.png;
    package = inputs.hydra.packages.${pkgs.system}.default;

    useSubstitutes = true;
    minimumDiskFree = 5;
    minimumDiskFreeEvaluator = 5;

    hydraURL = "https://hydra.ysun.co";
    listenHost = "127.0.0.1";
    port = 10069;
    notificationSender = "hydra@localhost";

    extraConfig =
      # basic config
      ''
        tracker = <script defer data-domain="hydra.ysun.co" src="https://stats.ysun.co/js/script.file-downloads.hash.outbound-links.js"></script>

        email_notification = 0

        <dynamicruncommand>
          enable = 1
        </dynamicruncommand>
      '' + # generic oidc
      ''
        enable_hydra_login = 0

        enable_oidc_login = 1
        oidc_client_id = "hydra"
        oidc_scope = "openid email profile groups"
        oidc_auth_uri = "https://sso.ysun.co/ui/oauth2"
        oidc_token_uri = "https://sso.ysun.co/oauth2/token"
        oidc_userinfo_uri = "https://sso.ysun.co/oauth2/openid/hydra/userinfo"
        include ${config.sops.secrets.hydra.path}

        <oidc_role_mapping>
          admins = admin
          admins = bump-to-front
          users = cancel-build
          users = eval-jobset
          users = create-projects
          users = restart-jobs
        </oidc_role_mapping>
      '';
    /* + # ldap config
      ''
      <ldap>
        <config>
          <credential>
            class = Password
            password_field = password
            password_type = self_check
          </credential>
          <store>
            class = LDAP
            ldap_server = "ldaps://ldap.ysun.co"
            <ldap_server_options>
              timeout = 30
            </ldap_server_options>
            binddn = "dn=token"
            include ${config.sops.secrets.hydra.path}
            start_tls = 0
            <start_tls_options>
              verify = none
            </start_tls_options>
            user_basedn = "dc=ysun,dc=co"
            user_filter = "(&(class=person)(name=%s))"
            user_scope = one
            user_field = name
            <user_search_options>
              attrs = "+"
              attrs = "cn"
              attrs = "mail"
              deref = always
            </user_search_options>
            use_roles = 1
            role_basedn = "dc=ysun,dc=co"
            role_filter = "(&(class=group)(member=%s))"
            role_scope = one
            role_field = name
            role_value = spn
            <role_search_options>
              attrs = "+"
              attrs = "cn"
              deref = always
            </role_search_options>
          </store>
        </config>
        <role_mapping>
          hydra.admins = admin
          hydra.admins = bump-to-front
          hydra.users = cancel-build
          hydra.users = eval-jobset
          hydra.users = create-projects
          hydra.users = restart-jobs
        </role_mapping>
      </ldap>
    ''; */
  };

  nix = {
    settings.allowed-uris = [
      "flake:"
      "git+https:"
      "git+ssh:"
      "github:"
      "gitlab:"
      "https:"
      "path:"
      "sourcehut:"
    ];

    buildMachines = [
      {
        hostName = "localhost";
        system = config.nixpkgs.hostPlatform.system;
        supportedFeatures = [
          "kvm"
          "nixos-test"
          "big-parallel"
          "benchmark"
        ];
        maxJobs = 8;
      }
    ];

    extraOptions = ''
      build-timeout = 86400  # 24 hours
    '';
  };
}
