# Dotfiles

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

A hacky `nix` based config that works on both NixOS and macOS.

## Notes

For VxLAN:

```nix
{
  networking.firewall.allowedUDPPorts = [ 4789 ];
  systemd.network = {
    networks."45-vx0" = {
      name = "vx0";
      address = [ "100.66.33.17/22" "2a0e:8f01:1000:9::111/64" ];
    };
    netdevs."45-vx0" = {
      netdevConfig = {
        Name = "vx0";
        Kind = "vxlan";
      };
      vxlanConfig = {
        VNI = 9559;
        Local = lib.blueprint.hosts.kongo.ipv4;
        Remote = "156.231.102.211";
        DestinationPort = 4789;
        Independent = true;
      };
    };
  };
}
```

IPv6 works but IPv4 doesn't?

```sh
sudo tcpdump -e -nn -i vx0
```

MTU (DF bit set by default)?

Firewall?

## Templates

Project templates available for:

- [Go](/templates/go)
- [Python](/templates/python)
- [Rust](/templates/rust)
- [Typst](/templates/typst)

```shell
nix flake [init|new] -t github:stepbrobd/dotfiles#{go|python|rust|typst}
```

## License

The contents inside this repository, excluding all submodules, are licensed under the [MIT License](license.txt).
Third-party file(s) and/or code(s) are subject to their original term(s) and/or license(s).
