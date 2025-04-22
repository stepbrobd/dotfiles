{ pkgs }:

pkgs.caddy.withPlugins {
  hash = "sha256-Rnroq/pv83PUWs8x2Ag3ZjsxxVmFzHc++5H84iwlYfU=";
  plugins = [
    "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
    "github.com/caddy-dns/cloudflare@v0.2.2-0.20250420134112-006ebb07b349"
  ];
}
