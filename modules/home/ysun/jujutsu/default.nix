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
        inherit key;
        sign-all = signByDefault;
        backend = "gpg"; # track git settings
      };
    };
  };
}
