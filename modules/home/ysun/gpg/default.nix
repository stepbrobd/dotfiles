# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  config = lib.mkMerge [
    {
      programs.gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
        mutableKeys = true;
        mutableTrust = true;
        publicKeys = [
          {
            source = ./pgp.asc;
            trust = "ultimate";
          }
        ];
      };
    }

    (lib.mkIf pkgs.stdenv.isLinux {
      services.gpg-agent = {
        enable = true;
        extraConfig = ''
          allow-loopback-pinentry
        '';
      };
    })
  ];
}
