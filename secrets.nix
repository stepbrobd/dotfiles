let
  fwl-13 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVZ9mzYNxccuh3uQR7Hly4KjhbRh4s6UlGQe2GjMtIC ysun@fwl-13";
  mbp-14 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw ysun@mbp-14";
  mbp-16 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVktHp6yjTknysVbU24K014tFKCIIM3/rWqZV591NRn ysun@mbp-16";

  zrh-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATBSfq95xFwSazFiulDnNIZGqj0Aw7gEvw9LxF96PBv root@zrh-1";

  ysun = [ fwl-13 mbp-14 mbp-16 ];
in
{
  "secrets/pgp.age".publicKeys = ysun;
  "secrets/smtp.age".publicKeys = ysun;

  "secrets/fwl-13.age".publicKeys = ysun;
  "secrets/mbp-14.age".publicKeys = ysun;
  "secrets/mbp-16.age".publicKeys = ysun;

  "secrets/cloudflare.age".publicKeys = ysun ++ [ zrh-1 ];
  "secrets/plausible.adm.age".publicKeys = ysun ++ [ zrh-1 ];
  "secrets/plausible.mal.age".publicKeys = ysun ++ [ zrh-1 ];
  "secrets/plausible.mmd.age".publicKeys = ysun ++ [ zrh-1 ];
  "secrets/plausible.srv.age".publicKeys = ysun ++ [ zrh-1 ];
  "secrets/vaultwarden.age".publicKeys = ysun ++ [ zrh-1 ];
}
