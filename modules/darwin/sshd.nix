{
  system.activationScripts.extraActivation.text = ''
    if [[ "$(systemsetup -getremotelogin | sed 's/Remote Login: //')" == "Off" ]]; then
      launchctl load -w /System/Library/LaunchDaemons/ssh.plist
    fi
  '';

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
}
