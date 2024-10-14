{ config, ... }:

{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = with config.programs.git; {
        name = userName;
        email = userEmail;
      };

      signing = with config.programs.git.signing; {
        sign-all = signByDefault;
        key = key;
        backend = "gpg"; # track git settings
      };
    };
  };
}
