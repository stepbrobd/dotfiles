{ pkgs }:

pkgs.caddy.withPlugins {
  hash = "sha256-g8TfkhhtKLxFKuJqLjyBclA1vMaT9pnz+/Wjs+5ceEg=";
  plugins = [
    "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
    "github.com/caddy-dns/cloudflare@v0.2.2-0.20250724223520-f589a18c0f5d"
    "github.com/caddyserver/cache-handler@v0.16.0"
    "github.com/darkweak/storages/badger/caddy@v0.0.15"
  ];
}
