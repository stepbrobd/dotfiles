let
  fwl-13 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVZ9mzYNxccuh3uQR7Hly4KjhbRh4s6UlGQe2GjMtIC ysun@fwl-13";
  mbp-14 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw ysun@mbp-14";
  mbp-16 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVktHp6yjTknysVbU24K014tFKCIIM3/rWqZV591NRn ysun@mbp-16";

  vault = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOh8T05Pi46149ss62ACAqQ94Y3VagiLpB76SZO7OXcW root@vault";

  ysun = [ fwl-13 mbp-14 mbp-16 ];
in
{
  "secrets/pgp.age".publicKeys = ysun;

  "secrets/fwl-13.age".publicKeys = ysun;
  "secrets/mbp-14.age".publicKeys = ysun;
  "secrets/mbp-16.age".publicKeys = ysun;

  "secrets/vaultwarden.age".publicKeys = ysun ++ [ vault ];
}
