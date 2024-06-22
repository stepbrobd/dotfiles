let
  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVZ9mzYNxccuh3uQR7Hly4KjhbRh4s6UlGQe2GjMtIC"; # framework
  macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw"; # macbook

  odake = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAs7yXRw7MplEON8Fxk+teNkQdD4k/xOBsMdcxlXn6CC"; # host@nrt-1
  lagern = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATBSfq95xFwSazFiulDnNIZGqj0Aw7gEvw9LxF96PBv"; # host@zrh-1
  bachtel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHLLHiyDq4GcetByxY0Gy2TeokjdXt2B2L20sFyZFlg"; # host@zrh-2

  ysun = [ framework macbook ];
  kichinose = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8LagJKcgCTZMrfGHTUE4y8B6g/5wgq+ufKHblSH81n" ];
in
{
  "secrets/pgp.age".publicKeys = ysun;
  "secrets/smtp.age".publicKeys = ysun;

  "secrets/cache.pem.age".publicKeys = ysun ++ [ odake ];
  "secrets/hydra-notify.age".publicKeys = ysun ++ [ odake ];

  "secrets/cloudflare-kichinose.age".publicKeys = kichinose ++ [ lagern ];
  "secrets/cloudflare-ysun.age".publicKeys = ysun ++ [
    odake
    lagern
    bachtel
  ];
  "secrets/plausible.adm.age".publicKeys = ysun ++ [ lagern ];
  "secrets/plausible.mal.age".publicKeys = ysun ++ [ lagern ];
  "secrets/plausible.mmd.age".publicKeys = ysun ++ [ lagern ];
  "secrets/plausible.srv.age".publicKeys = ysun ++ [ lagern ];
}
