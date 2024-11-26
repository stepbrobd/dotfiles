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
        sign-all = true;
        backend = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
    };
  };
}
