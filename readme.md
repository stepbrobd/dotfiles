# Dotfiles

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

A hacky `nix` based config that works on both NixOS and macOS.

## Notes

Todo: export IXP routes to kernel.

VxLAN IPv4 connectivity issue with BGP.Exchange is caused by Tailscale claiming
the entirety of CGNAT IPv4 block.

Work around by any of these:

- Use BGP multi-protocol extension to advertise IPv4 over IPv6 session
- Inject specific rules to before in firewall before Tailscale's 100.64.0.0/10
  rule
- Use VRF

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

The contents inside this repository, excluding all submodules, are licensed
under the [MIT License](license.txt). Third-party file(s) and/or code(s) are
subject to their original term(s) and/or license(s).
