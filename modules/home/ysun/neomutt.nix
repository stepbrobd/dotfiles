{ lib, ... }:

{ config, pkgs, ... }:

{
  accounts.email = {
    maildirBasePath = "${config.xdg.dataHome}/mail";

    accounts =
      let
        realName = "Yifei Sun";

        mbsync.enable = true;
        msmtp.enable = true;
        notmuch = {
          enable = true;
          neomutt = {
            enable = true;
            virtualMailboxes = [ ];
          };
        };

        neomutt = {
          enable = true;
          mailboxType = "imap";
        };

        mkpass = key: "${lib.getExe' pkgs.toybox "cat"} ${config.sops.defaultSymlinkPath}/${key}";
      in
      {
        goo = rec {
          inherit realName mbsync msmtp notmuch neomutt;
          address = "ysun@goo.jp";
          userName = address;
          passwordCommand = mkpass "mail/goo/pass";
          imap = {
            host = "imap.mail.goo.jp";
            port = 993;
          };
          smtp = {
            host = "smtp.mail.goo.jp";
            port = 465;
          };
        };

        softbank = rec {
          inherit realName mbsync msmtp notmuch neomutt;
          address = "ysun@i.softbank.jp";
          userName = address;
          passwordCommand = mkpass "mail/softbank/pass";
          imap = {
            host = "imap.softbank.jp";
            port = 993;
          };
          smtp = {
            host = "smtp.softbank.jp";
            port = 465;
          };
        };

        stepbrobd = rec {
          primary = true;
          inherit realName mbsync msmtp notmuch neomutt;
          address = "ysun@stepbrobd.com";
          userName = address;
          passwordCommand = mkpass "mail/stepbrobd/pass";
          imap = {
            host = "imap.purelymail.com";
            port = 993;
          };
          smtp = {
            host = "smtp.purelymail.com";
            port = 465;
          };
        };
      };
  };

  sops.secrets."mail/goo/pass" = { };
  sops.secrets."mail/softbank/pass" = { };
  sops.secrets."mail/stepbrobd/pass" = { };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch.enable = true;

  programs.neomutt = {
    enable = true;
    vimKeys = true;

    sidebar = {
      enable = true;
      shortPath = true;
      width = 25;
    };

    extraConfig = ''
      color normal		default default
      color index		brightblue default ~N
      color index		red default ~F
      color index		blue default ~T
      color index		brightred default ~D
      color body		brightgreen default         (https?|ftp)://[\-\.+,/%~_:?&=\#a-zA-Z0-9]+
      color body		brightgreen default         [\-\.+_a-zA-Z0-9]+@[\-\.a-zA-Z0-9]+
      color attachment	magenta default
      color signature		brightwhite default
      color search		brightred black

      color indicator		black cyan
      color error		red default
      color status		white brightblack
      color tree		white default
      color tilde		cyan default

      color hdrdefault	brightblue default
      color header		cyan default "^From:"
      color header	 	cyan default "^Subject:"

      color quoted		cyan default
      color quoted1		brightcyan default
      color quoted2		blue default
      color quoted3		green default
      color quoted4		yellow default
      color quoted5		red default
    '';
  };
}
