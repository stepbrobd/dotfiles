{ config, ... }:

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

    useSubstitutes = true;
    minimumDiskFree = 5;
    minimumDiskFreeEvaluator = 5;

    hydraURL = "https://hydra.ysun.co";
    listenHost = "127.0.0.1";
    port = 10069;
    notificationSender = "hydra@localhost";

    extraConfig = ''
      tracker = <script defer data-domain="hydra.ysun.co" src="https://stats.ysun.co/js/script.file-downloads.hash.outbound-links.js"></script>

      email_notification = 0

      <dynamicruncommand>
        enable = 1
      </dynamicruncommand>

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
    '';
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
