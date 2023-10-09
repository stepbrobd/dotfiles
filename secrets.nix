let
  mbp-14 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw ysun@mbp-14";
  mbp-16 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVktHp6yjTknysVbU24K014tFKCIIM3/rWqZV591NRn ysun@mbp-16";
in
{
  "secrets/mbp-14.age".publicKeys = [ mbp-14 ];
  "secrets/mbp-16.age".publicKeys = [ mbp-16 ];
}
