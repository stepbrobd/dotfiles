{ config, ... }:

{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = with config.programs.git; {
        name = userName;
        email = userEmail;
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
