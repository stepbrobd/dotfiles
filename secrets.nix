let
  framework = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVZ9mzYNxccuh3uQR7Hly4KjhbRh4s6UlGQe2GjMtIC"; # framework
  macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw"; # macbook

  nrt-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAs7yXRw7MplEON8Fxk+teNkQdD4k/xOBsMdcxlXn6CC"; # host@nrt-1
  zrh-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATBSfq95xFwSazFiulDnNIZGqj0Aw7gEvw9LxF96PBv"; # host@zrh-1
  zrh-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDHLLHiyDq4GcetByxY0Gy2TeokjdXt2B2L20sFyZFlg"; # host@zrh-2

  ysun = [ framework macbook ];
in
{
  "secrets/pgp.age".publicKeys = ysun;
  "secrets/smtp.age".publicKeys = ysun;

  "secrets/cache.pem.age".publicKeys = ysun ++ [ nrt-1 ];
  "secrets/hydra-notify.age".publicKeys = ysun ++ [ nrt-1 ];

  "secrets/cloudflare.age".publicKeys = ysun ++ [
    nrt-1
    zrh-1
    zrh-2
  ];
  "secrets/plausible.adm.age".publicKeys = ysun ++ [ zrh-1 ];
  "secrets/plausible.mal.age".publicKeys = ysun ++ [ zrh-1 ];
  "secrets/plausible.mmd.age".publicKeys = ysun ++ [ zrh-1 ];
  "secrets/plausible.srv.age".publicKeys = ysun ++ [ zrh-1 ];
}
