{ config
, lib
, pkgs
, ...
}:

{
  programs.zsh.enable = true;

  users.users.ysun = {
    shell = pkgs.zsh;

    description = "Yifei Sun";
    home =
      if pkgs.stdenv.isLinux
      then lib.mkDefault "/home/ysun"
      else if pkgs.stdenv.isDarwin
      then lib.mkDefault "/Users/ysun"
      else abort "Unsupported OS";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVZ9mzYNxccuh3uQR7Hly4KjhbRh4s6UlGQe2GjMtIC" # ysun@fwl-13
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw" # ysun@mbp-14
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVktHp6yjTknysVbU24K014tFKCIIM3/rWqZV591NRn" # ysun@mbp-16
    ];
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" "audio" "video" ];
    hashedPassword = "$y$j9T$.4YGom.yj/t0BqlWv3ysg.$f.LzZrxQpB.vpmKd7mu4yxYWiERgEtTAxJHIGti2vg2";
  };
}
