{ pkgs }:

pkgs.caddy.withPlugins {
  hash = "sha256-9siUzz6ahfsfqhB2TaXMpNwQIDuTCMwkSfnKHOiqNSc=";
  plugins = [
    "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
    "github.com/caddy-dns/cloudflare@v0.2.2-0.20250506153119-35fb8474f57d"
  ];
}
