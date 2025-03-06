{ lib, config, ... }:

let
  cfg = config.services.as10779;
in
{
  # sops.secrets.bgp = {
  #   sopsFile = ./secrets.yaml;
  #   mode = "440";
  #   owner = config.systemd.services.bird.serviceConfig.User;
  #   group = config.systemd.services.bird.serviceConfig.Group;
  #   reloadUnits = [ config.systemd.services.bird.name ];
  # };

  services.as10779 = {
    enable = false;
    # FIXME: it crashes for no reason?
    # bird.service: Failed with result 'core-dump'.
    # Process 2217 (bird) of user 993 dumped core.
    # Process 2217 (bird) of user 993 terminated abnormally with signal 6/ABRT, processing...
    # Module libz.so.1 without build-id.
    # Module libssh.so.4 without build-id.
    # Stack trace of thread 2218:
    # #0  0x00007f792ca9916c __pthread_kill_implementation (libc.so.6 + 0x9916c)
    # #1  0x00007f792ca40e86 raise (libc.so.6 + 0x40e86)
    # #2  0x00007f792ca2893a abort (libc.so.6 + 0x2893a)
    # #3  0x00000000004d6a78 n/a (n/a + 0x0)
    # ELF object binary architecture: AMD x86-64

    router = {
      id = "185.194.53.29";
      secret = config.sops.secrets.bgp.path;
      source = {
        inherit (lib.blueprint.hosts.toompea) ipv4 ipv6;
        explicit = false;
      };
      sessions = [
        {
          name = "xtom";
          password = "PASS_AS3204";
          type = "direct";
          neighbor = {
            asn = 3204;
            ipv4 = "185.194.53.4";
            ipv6 = "2a04:6f00:4::4";
          };
          import = {
            ipv4 = "import all;";
            ipv6 = "import all;";
          };
          export = {
            ipv4 = ''export where proto = "${cfg.router.static.ipv4.name}";'';
            ipv6 = ''export where proto = "${cfg.router.static.ipv6.name}";'';
          };
        }
        {
          name = "bgptools";
          password = "PASS_AS212232";
          type = "multihop";
          neighbor = {
            asn = 212232;
            ipv4 = "185.230.223.78";
            ipv6 = "2a0c:2f07:9459::b6";
          };
          import = {
            ipv4 = "import none;";
            ipv6 = "import none;";
          };
          export = {
            ipv4 = "export all;";
            ipv6 = "export all;";
          };
        }
      ];
    };

    inherit (lib.blueprint.hosts.toompea.as10779) local peers;
  };
}
