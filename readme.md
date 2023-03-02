# Dotfiles

Dotfiles with setup script (pseudo-idempotent), repository should be in `~/.config/dotfiles` directory.

Managed by [Home Manager](https://github.com/nix-community/home-manager)'s [`home.activation`](https://rycee.gitlab.io/home-manager/options.html#opt-home.activation):

```nix
{
  dotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #!/bin/zsh
    export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/StepBroBD/Dotfiles/master/setup.sh | zsh >/dev/null 2>&1
  '';
}
```

Standalone installation:

```shell
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/StepBroBD/Dotfiles/master/setup.sh | zsh
```

## License

This repository content excluding all submodules is licensed under the [WTFPL License](LICENSE.md), third-party code are subject to their original license.
