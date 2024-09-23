{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;

    extraConfig = ''
      Host ceylon
        User yifei
        ProxyCommand ssh -W %h:%p yifei@133.11.234.34
        HostName 133.11.234.39 # ceylon

      Host uva
        User yifei
        ProxyCommand ssh -W %h:%p yifei@133.11.234.34
        HostName 133.11.234.42 # uva

      Host vpi
        User yifei
        ProxyCommand ssh -W %h:%p yifei@133.11.234.34
        HostName vpi
    ''/* + "\n" +
      (if pkgs.stdenv.isLinux then ''
      Host *
          IdentityAgent "~/.1password/agent.sock"
      '' else if pkgs.stdenv.isDarwin then ''
      Host *
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '' else abort "Unsupported OS") */;
  };
}
