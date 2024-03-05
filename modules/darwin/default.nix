# nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 48;
      largesize = 64;
      minimize-to-application = true;
      show-recents = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = false;
      CreateDesktop = false;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };

  environment.etc."ssh/sshd_config".text = ''
    Include            /etc/ssh/sshd_config.d/*
    AuthorizedKeysFile .ssh/authorized_keys

    AuthorizedPrincipalsFile        none
    ChallengeResponseAuthentication no
    KbdInteractiveAuthentication    no
    PasswordAuthentication          no
    PermitRootLogin                 no
    StrictModes                     yes
    UsePAM                          yes

    Ciphers       chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
    KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,sntrup761x25519-sha512@openssh.com
    Macs          hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com
  '';

  security.pam.enableSudoTouchIdAuth = true;
}
