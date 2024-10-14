{ config, ... }:

{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = config.programs.git.userName;
        email = config.programs.git.userEmail;
      };
      signing = {
        sign-all = config.programs.git.signing.signByDefault;
        key = config.programs.git.signing.key;
        backend = "gpg"; # track git settings
      };
    };
  };
}
