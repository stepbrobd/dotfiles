{ config, pkgs, ... }:

{
  programs.jujutsu = {
    enable = true;

    # https://github.com/nixos/nixpkgs/issues/456113
    # https://github.com/jkachmar/tartarus/commit/423a1b2d787448400b507a480e0646b623489cbc
    package =
      if pkgs.stdenv.hostPlatform.isDarwin then
        pkgs.jujutsu.override
          {
            rustPlatform = pkgs.rustPlatform // {
              buildRustPackage = pkgs.rustPlatform.buildRustPackage.override {
                cargoNextestHook = null;
              };
            };
          }
      else
        pkgs.jujutsu;

    settings = {
      user = with config.programs.git.settings.user; {
        inherit name email;
      };

      signing = {
        signing.behavior = "own";
        backend = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };

      ui.default-command = "log";
    };
  };
}
