{ config, pkgs, ... }:

let inherit (pkgs) lib; in
{
  config = lib.mkIf config.services.bird2.enable {
    networking.firewall.allowedTCPPorts = [ 179 ];

    services.bird2 = {
      enable = false;
      checkConfig = false;

      config =
        let
          own = {
            asn = "<Own ASN>";
            ipv4 = "<Router IPv4>";
            ipv6 = "<Router IPv6>";
          };

          announce = {
            ipv4 = [
              {
                prefix = "<IPv4 Block to be Announced>";
                msa = "<Most Specific Announcement>";
                origin = "<Origin ASN>";
              }
            ];
            ipv6 = [
              {
                prefix = "<IPv6 Block to be Announced>";
                msa = "<Most Specific Announcement>";
                origin = "<Origin ASN>";
              }
            ];
          };

          peer = [
            {
              name = "<Peer Name>";
              asn = "<Peer ASN>";
              ipv4 = "<Peer IPv4>";
              ipv6 = "<Peer IPv6>";
              multihop = "<Multihop>";
              password = "<BGP Password>";
            }
          ];
        in
        ''
          router id ${own.ipv4};

          protocol device {
            scan time 10;
          }

          protocol kernel {
            scan time 10;
            learn;
            persist;
            ipv4 {
              import all;
              export filter {
                if source = RTS_STATIC then reject;
                krt_prefsrc = ${own.ipv4};
                accept;
              };
            };
          }

          protocol kernel {
            scan time 10;
            learn;
            persist;
            ipv6 {
              import all;
              export filter {
                if source = RTS_STATIC then reject;
                krt_prefsrc = ${own.ipv6};
                accept;
              };
            };
          }

          function is_as_bogon() {
            return bgp_path ~ [
              0,                      # RFC 7607
              23456,                  # RFC 4893 AS_TRANS
              64496..64511,           # RFC 5398 and documentation/example ASNs
              #64512..65534,          # RFC 6996 Private ASNs
              65535,                  # RFC 7300 Last 16 bit ASN
              65536..65551,           # RFC 5398 and documentation/example ASNs
              65552..131071,          # RFC IANA reserved ASNs
              4200000000..4294967294, # RFC 6996 Private ASNs
              4294967295              # RFC 7300 Last 32 bit ASN
            ];
          }

          function is_net_bogon() {
            if net.type = NET_IP4 then return net ~ [
              0.0.0.0/8+,       # RFC 1122 'this' network
              10.0.0.0/8+,      # RFC 1918 private space
              100.64.0.0/10+,   # RFC 6598 Carrier grade nat space
              127.0.0.0/8+,     # RFC 1122 localhost
              169.254.0.0/16+,  # RFC 3927 link local
              172.16.0.0/12+,   # RFC 1918 private space
              192.0.2.0/24+,    # RFC 5737 TEST-NET-1
              192.88.99.0/24+,  # RFC 7526 6to4 anycast relay
              192.168.0.0/16+,  # RFC 1918 private space
              198.18.0.0/15+,   # RFC 2544 benchmarking
              198.51.100.0/24+, # RFC 5737 TEST-NET-2
              203.0.113.0/24+,  # RFC 5737 TEST-NET-3
              224.0.0.0/4+,     # multicast
              240.0.0.0/4+      # reserved
            ];
            return net ~ [
              ::/8+,          # RFC 4291 IPv4-compatible, loopback, et al
              0100::/64+,     # RFC 6666 Discard-Only
              2001:2::/48+,   # RFC 5180 BMWG
              2001:10::/28+,  # RFC 4843 ORCHID
              2001:db8::/32+, # RFC 3849 documentation
              2002::/16+,     # RFC 7526 6to4 anycast relay
              3ffe::/16+,     # RFC 3701 old 6bone
              fc00::/7+,      # RFC 4193 unique local unicast
              fe80::/10+,     # RFC 4291 link local unicast
              fec0::/10+,     # RFC 3879 old site local unicast
              ff00::/8+       # RFC 4291 multicast
            ];
          }

          function is_net_announced() {
            if net.type = NET_IP4 then return net ~ [
              ${
                lib.concatMapStringsSep "\n" (r: ''
                  ${r.prefix}+
                '') announce.ipv4
              }
            ];
            return net ~ [
              ${
                lib.concatMapStringsSep "\n" (r: ''
                  ${r.prefix}+
                '') announce.ipv6
              }
            ];
          }

          protocol static {
            ipv4;
            ${
              lib.concatMapStringsSep "\n" (r: ''
                route ${r.prefix} via ${own.ipv4};
              '') announce.ipv4
            }
          }

          protocol static {
            ipv6;
            ${
              lib.concatMapStringsSep "\n" (r: ''
                route ${r.prefix} via ${own.ipv6};
              '') announce.ipv6
            }
          }

          ${lib.concatMapStringsSep "\n" (p: ''
            protocol bgp ${p.name}4 {
              graceful restart on;
              multihop ${p.multihop};
              local as ${own.asn};
              source address ${own.ipv4};
              neighbor ${p.ipv4} as ${p.asn};
              password "${p.password}";
              ipv4 {
                import filter {
                  if is_as_bogon() then reject;
                  if is_net_bogon() then reject;
                  accept;
                };
                export filter {
                  if is_as_bogon() then reject;
                  if is_net_bogon() then reject;
                  if !is_net_announced() then reject;
                  accept;
                };
              };
            }
          '') peer}

          ${lib.concatMapStringsSep "\n" (p: ''
            protocol bgp ${p.name}6 {
              graceful restart on;
              multihop ${p.multihop};
              local as ${own.asn};
              source address ${own.ipv6};
              neighbor ${p.ipv6} as ${p.asn};
              password "${p.password}";
              ipv6 {
                import filter {
                  if is_as_bogon() then reject;
                  if is_net_bogon() then reject;
                  accept;
                };
                export filter {
                  if is_as_bogon() then reject;
                  if is_net_bogon() then reject;
                  if !is_net_announced() then reject;
                  accept;
                };
              };
            }
          '') peer}
        '';
    };
  }
