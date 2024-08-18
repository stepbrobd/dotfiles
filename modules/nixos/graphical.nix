importApplyArgs: _:

{
  imports = [
    ./1password.nix
    ./fonts.nix
    ./i18n.nix
    ./tailscale.nix

    (import ./desktop.nix importApplyArgs)
  ];
}
