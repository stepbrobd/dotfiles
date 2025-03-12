{ pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Etc/UTC";

  environment.systemPackages = with pkgs; [
    cacert

    coreutils
    inetutils
    dnsutils

    direnv
    nix-direnv
    vim
    git
    curl
    wget
  ];

  users.mutableUsers = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  services.openssh.enable = true;
}
