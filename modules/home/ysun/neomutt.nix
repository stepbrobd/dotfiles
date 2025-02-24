{ config, ... }:

{
  programs.neomutt = {
    enable = true;
    vimKeys = true;

    extraConfig = ''
      set folder=${config.xdg.dataHome}/neomutt

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
