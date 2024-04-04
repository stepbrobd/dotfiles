# Dotfiles

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

A hacky `nix` based config that works on both NixOS and macOS.

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
