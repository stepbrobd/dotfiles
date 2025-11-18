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
          neomutt.enable = true;
        };

        neomutt = {
          enable = true;
          mailboxType = "imap";
          extraMailboxes = [
            "Drafts"
            "Sent"
            "Trash"
            "Junk"
            "Archive"
          ];
        };

        thunderbird = {
          enable = true;
        };

        mkpass = key: "${lib.getExe' pkgs.toybox "cat"} ${config.sops.defaultSymlinkPath}/mail/${key}/pass";
      in
      {
        Inria = rec {
          inherit
            realName
            mbsync
            msmtp
            notmuch
            neomutt
            thunderbird
            ;
          address = "yifei.sun@inria.fr";
          userName = address;
          passwordCommand = mkpass "inria";
          imap = {
            host = "zimbra.inria.fr";
            port = 993;
          };
          smtp = {
            host = "smtp.inria.fr";
            port = 587;
          };
        };

        "ENS de Lyon" = rec {
          inherit
            realName
            mbsync
            msmtp
            notmuch
            neomutt
            thunderbird
            ;
          address = "yifei.sun@ens-lyon.fr";
          userName = address;
          passwordCommand = mkpass "ens";
          imap = {
            host = "imap.ens-lyon.fr";
            port = 993;
          };
          smtp = {
            host = "smtp.ens-lyon.fr";
            port = 587;
          };
        };

        UGA = rec {
          inherit
            realName
            mbsync
            msmtp
            notmuch
            neomutt
            thunderbird
            ;
          address = "yifei.sun@univ-grenoble-alpes.fr";
          userName = address;
          passwordCommand = mkpass "uga";
          imap = {
            host = "zimbra.univ-grenoble-alpes.fr";
            port = 993;
          };
          smtp = {
            host = "smtps.univ-grenoble-alpes.fr";
            port = 465;
          };
        };

        SoftBank = rec {
          inherit
            realName
            mbsync
            msmtp
            notmuch
            neomutt
            thunderbird
            ;
          address = "ysun@i.softbank.jp";
          userName = address;
          passwordCommand = mkpass "softbank";
          imap = {
            host = "imap.softbank.jp";
            port = 993;
          };
          smtp = {
            host = "smtp.softbank.jp";
            port = 465;
          };
        };

        StepBroBD = rec {
          primary = true;
          inherit
            realName
            mbsync
            msmtp
            notmuch
            neomutt
            thunderbird
            ;
          address = "ysun@stepbrobd.com";
          userName = address;
          passwordCommand = mkpass "stepbrobd";
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

  sops.secrets."mail/softbank/pass" = { };
  sops.secrets."mail/stepbrobd/pass" = { };
  sops.secrets."mail/inria/pass" = { };
  sops.secrets."mail/ens/pass" = { };
  sops.secrets."mail/uga/pass" = { };

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch.enable = true;

  programs.thunderbird = {
    enable = true;
    profiles.Default.isDefault = true;
  };

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
      color attachment	        magenta default
      color signature		brightwhite default
      color search		brightred black

      color indicator		black cyan
      color error		red default
      color status		white brightblack
      color tree		white default
      color tilde		cyan default

      color hdrdefault	        brightblue default
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
