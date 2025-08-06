{ config, pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Etc/UTC";

  environment.systemPackages = with pkgs; [
    cacert
    file
    vim

    cfspeedtest
    coreutils
    dnsutils
    inetutils
    mtr
    tcpdump

    curlHTTP3
    wget
  ];

  users.mutableUsers = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  services.openssh =
    let inherit (pkgs) lib; in
    {
      enable = true;
      hostKeys = lib.mkForce [{ type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }];
      settings.PermitRootLogin = lib.mkForce "no";
    };

  programs.zsh.enableCompletion = pkgs.lib.mkForce false;
  programs.bash.completion.enable = pkgs.lib.mkForce false;

  services.journald.extraConfig = ''
    SystemMaxUse=64M
  '';
  services.logrotate.settings =
    let
      inherit (pkgs.lib) mkDefault mapAttrs;
    in
    {
      "/var/log/btmp" = mapAttrs (_: mkDefault) {
        frequency = "monthly";
        rotate = 1;
        create = "0660 root ${config.users.groups.utmp.name}";
        minsize = "1M";
      };
      "/var/log/wtmp" = mapAttrs (_: mkDefault) {
        frequency = "monthly";
        rotate = 1;
        create = "0664 root ${config.users.groups.utmp.name}";
        minsize = "1M";
      };
    };
}
