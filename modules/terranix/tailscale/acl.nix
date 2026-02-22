{ lib, ... }:

{ ... }:

let
  tag = {
    golink = "tag:golink";
    routee = "tag:routee";
    router = "tag:router";
    server = "tag:server";
  };

  autogroup = {
    admin = "autogroup:admin";
    member = "autogroup:member";
    self = "autogroup:self";
    shared = "autogroup:shared";
    internet = "autogroup:internet";
    nonroot = "autogroup:nonroot";
  };

  self = {
    email = "ysun@hey.com";
    username = "ysun";
  };
in
{
  resource.tailscale_acl.acl = {
    overwrite_existing_content = true;
    reset_acl_on_destroy = true;

    acl = lib.toJSON {
      tagOwners = {
        ${tag.golink} = [ autogroup.admin ];
        ${tag.routee} = [ autogroup.admin ];
        ${tag.router} = [ autogroup.admin ];
        ${tag.server} = [ autogroup.admin ];
      };

      grants = [
        # full access for admins
        {
          src = [ autogroup.admin ];
          dst = [ "*" ];
          ip = [ "*" ];
        }
        # users within tailnet get to use golink
        {
          src = [ autogroup.member ];
          dst = [ tag.golink ];
          app."tailscale.com/cap/golink" = [{ admin = true; }];
        }
        # users within tailnet get to use
        # their own devices, golink, and exit nodes
        {
          src = [ autogroup.member ];
          dst = [ autogroup.self tag.golink autogroup.internet ];
          ip = [ "*" ];
        }
        # devices shared outside with other ppl
        # can use as exit nodes
        {
          src = [ autogroup.shared ];
          dst = [ autogroup.internet ];
          ip = [ "*" ];
        }
        # routers and servers rules
        {
          src = with tag; [ routee router server ];
          dst = [
            # tags
            tag.routee
            tag.router
            tag.server
            # tailscale
            "100.64.0.0/10"
            "fd7a:115c:a1e0::/48"
            # own prefixes
            "23.161.104.0/24"
            "44.32.189.0/24"
            "192.104.136.0/24"
            "2602:f590::/36"
          ];
          ip = [ "1-21" "23-65535" ];
        }
      ];

      ssh = [
        {
          action = "accept";
          src = [ autogroup.admin ];
          dst = [ autogroup.self tag.routee tag.router tag.server ];
          users = [ autogroup.nonroot "root" ];
        }
        {
          action = "accept";
          src = [ autogroup.member ];
          dst = [ autogroup.self ];
          users = [ autogroup.nonroot "root" ];
        }
      ];

      autoApprovers = {
        exitNode = with tag; [ routee router server ];
        routes = {
          "23.161.104.0/24" = with tag; [ routee router server ];
          "44.32.189.0/24" = with tag; [ routee router server ];
          "192.104.136.0/24" = with tag; [ routee router server ];
          "2602:f590::/36" = with tag; [ routee router server ];
        };
      };

      # ensure each device gets a /32 rule
      # for their v4 address under CGNAT range
      OneCGNATRoute = "";

      nodeAttrs = [
        # test https://github.com/tailscale/tailscale/issues/18758
        { target = [ "*" ]; app."ysun.co/tscgnat" = [{ cidr = "100.64.0.0/10"; chain = "both"; verdict = "drop"; }]; }
        # see above
        # in tailscale/tailcfg/tailcfg.go:
        # NodeAttrOneCGNATEnable NodeCapability = "one-cgnat?v=false"
        { target = [ "*" ]; attr = [ "one-cgnat?v=false" "funnel" "nextdns:d8664a" ]; }
        { target = [ self.email ]; attr = [ "mullvad" ]; }
        # 100.100.20.0/24 reserved for devices that are shared into my tailnet
        { target = with tag; [ routee router ]; ipPool = [ "100.100.20.0/24" ]; }
        { target = [ tag.server ]; ipPool = [ "100.100.30.0/24" ]; }
        { target = [ tag.golink ]; ipPool = [ "100.100.40.0/24" ]; }
        { target = [ autogroup.admin self.email ]; ipPool = [ "100.100.50.0/24" ]; }
      ];

      tests =
        let
          bgp = [
            "23.161.104.0:179"
            "44.32.189.0:179"
            "192.104.136.0:179"
            "[2602:f590::]:179"
          ];
          ssh = [
            "100.100.10.0:22"
            "100.100.20.0:22"
            "100.100.30.0:22"
            "100.100.40.0:22"
            "100.100.50.0:22"
          ];
        in
        [
          # routers should at least have access to own prefixes bgp port
          { src = tag.router; proto = "tcp"; accept = bgp; }
          # routers shouldn't ssh to any tailnet devices
          { src = tag.router; proto = "tcp"; deny = ssh; }
          # servers shouldn't ssh to any tailnet devices
          { src = tag.server; proto = "tcp"; deny = ssh; }
        ];

      sshTests = [{
        src = self.email;
        dst = [ tag.server ];
        accept = [ self.username ];
      }];
    };
  };
}
