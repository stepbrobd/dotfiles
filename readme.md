# Dotfiles

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

A hacky `nix` based config that works on both NixOS and macOS.

## Systems

NixOS: [Framework Laptop 13](/systems/ysun.co/fwl-13)

Nix-Darwin: [MacBook Pro 14"](/systems/ysun.co/mbp-14)

Nix-Darwin: [MacBook Pro 16"](/systems/ysun.co/mbp-16)

## Templates

Project templates available for:

- [Go](/templates/go)
- [Python](/templates/python)

```shell
nix flake init -t github:stepbrobd/dotfiles#{go,python}
```

## License

The contents inside this repository, excluding all submodules, are licensed under the [MIT License](license.md).
Third-party file(s) and/or code(s) are subject to their original term(s) and/or license(s).
