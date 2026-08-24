{ lib, ... }:

let
  # one prefix per line
  # ignore `#` comments and blank lines
  load = path: lib.filter
    (line: line != "" && !(lib.hasPrefix "#" line))
    (lib.map lib.trim (lib.splitString "\n" (builtins.readFile path)));

  v4 = load ./v4.txt;
  v6 = load ./v6.txt;

  hosts = lib.attrValues lib.blueprint.hosts;

  nets = family: lib.concatMap (net: net.${family}) (lib.attrValues lib.blueprint.net);

  # provider assigned addresses only
  # the ipam ones sit inside `net.ipam` and interval sets reject overlaps
  addrs = family: lib.filter (a: a != null) (lib.map (host: host.${family}) hosts);

  # dont drop our own ip set
  allow4 = nets "ipv4" ++ addrs "ipv4";
  allow6 = nets "ipv6" ++ addrs "ipv6";

  set = name: type: elements: ''
    set ${name} {
      type ${type}
      flags interval
      elements = { ${lib.concatStringsSep ", " elements} }
    }
  '';
in
{
  networking.nftables.tables.blocklist = {
    family = "inet";
    content = ''
      ${set "allow4" "ipv4_addr" allow4}
      ${set "allow6" "ipv6_addr" allow6}
      ${set "v4" "ipv4_addr" v4}
      ${set "v6" "ipv6_addr" v6}

      counter blocked4 { }
      counter blocked6 { }

      chain input {
        type filter hook input priority -200; policy accept;

        ct state established,related return

        ip saddr @allow4 return
        ip6 saddr @allow6 return

        ip saddr @v4 counter name blocked4 drop
        ip6 saddr @v6 counter name blocked6 drop
      }
    '';
  };
}
