# Dotfiles

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

A hacky config that works on both NixOS and macOS.

NixOS server config evaluation order: `inputs.autopilot` -> `lib/*` ->
`parts/configurations/server.nix` -> `lib.mkColmena` -> conversion:

```nix
nixosConfigurations = (import "${inputs.colmena}/src/nix/hive/eval.nix" {
  rawHive = ...;
}).nodes;
```

## Notes

Todo: export IXP routes to kernel.

VxLAN IPv4 connectivity issue with BGP.Exchange is caused by Tailscale claiming
the entirety of CGNAT IPv4 block.

Work around by any of these:

- Use BGP multi-protocol extension to advertise IPv4 over IPv6 session
- Inject specific rules to before in firewall before Tailscale's 100.64.0.0/10
  rule
- Use VRF

## License

The contents inside this repository, excluding all submodules, are licensed
under the [MIT License](license.txt). Third-party file(s) and/or code(s) are
subject to their original term(s) and/or license(s).
