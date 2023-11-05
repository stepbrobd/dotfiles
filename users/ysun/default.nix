{ config
, lib
, pkgs
, ...
}:

{
  users.users.ysun = {
    description = "Yifei Sun";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKS575waJuCMJT8HsnAnWLhpX3/IcToBwgjf8iel5TmZ ysun@fwl-13"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw ysun@mbp-14"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVktHp6yjTknysVbU24K014tFKCIIM3/rWqZV591NRn ysun@mbp-16"
    ];

    shell = pkgs.zsh;
  } // lib.optionals pkgs.stdenv.isLinux {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" "audio" "video" ];
    hashedPassword = "$y$j9T$.4YGom.yj/t0BqlWv3ysg.$f.LzZrxQpB.vpmKd7mu4yxYWiERgEtTAxJHIGti2vg2";
  };

  programs.zsh.enable = true;
}