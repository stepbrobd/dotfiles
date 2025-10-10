{ lib, ... }:

{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = lib.mkDefault false;
      addKeysToAgent = lib.mkDefault "no";
      compression = lib.mkDefault false;
      serverAliveInterval = 60;
      hashKnownHosts = lib.mkDefault false;
    };

    extraConfig =
      let
        proxy = "ProxyCommand ssh -W %h:%p yifei@133.11.234.34";
        targets = {
          yifei = [
            { ceylon = "133.11.234.39"; }
            { uva = "133.11.234.42"; }
            { vpi = "172.19.0.3"; }
          ];
          plask = [
            { plask = "133.11.234.43"; }
          ];
        };
        gen = targets:
          let
            users = lib.attrNames targets;
            configs = lib.concatLists (lib.map
              (user:
                let
                  hosts = targets.${user};
                  userConfigs = lib.map
                    (hostAttr:
                      let
                        host = lib.elemAt (lib.attrNames hostAttr) 0;
                        ip = hostAttr.${host};
                      in
                      ''
                        Host ${host}
                          User ${user}
                          ${proxy}
                          HostName ${ip}
                      ''
                    )
                    hosts;
                in
                userConfigs
              )
              users);
          in
          lib.concatStringsSep "\n" configs;
      in
      gen targets + "\n" + ''
        Host g5k
          User yisun
          Hostname access.grid5000.fr
          ForwardAgent no

        Host *.g5k
          User login
          ProxyCommand ssh g5k -W "$(basename %h .g5k):%p"
          ForwardAgent no
      ''
      /* + "\n" +
      (if pkgs.stdenv.isLinux then ''
      Host *
          IdentityAgent "~/.1password/agent.sock"
      '' else if pkgs.stdenv.isDarwin then ''
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '' else abort "Unsupported OS") */;
  };
}
