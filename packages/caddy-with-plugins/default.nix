{ caddy }:

caddy.withPlugins {
  plugins = [
    "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
    "github.com/caddy-dns/cloudflare@v0.2.2-0.20250724223520-f589a18c0f5d"
    "github.com/caddyserver/cache-handler@v0.16.0"
    "github.com/darkweak/storages/badger/caddy@v0.0.15" # getting storage backend error on 0.0.16
    "github.com/ueffel/caddy-brotli@v1.6.0"
    "github.com/darkweak/souin=github.com/darkweak/souin@v1.7.8-0.20250907151505-548a57d94fc5"
  ];
  hash = "sha256-TRweZxZZz0D2F4Ip9T3jNEkQ+Wv1+kNzgizQdIVtoPA=";
}
