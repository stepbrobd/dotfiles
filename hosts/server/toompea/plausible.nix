{
  services.plausible = {
    enable = true;
    domain = "stats.ysun.co";
    extraDomains = [ "stats.rkt.lol" ];
    database.postgres.setup = false;
  };
}
