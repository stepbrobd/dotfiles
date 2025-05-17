{ pkgs }:

pkgs.caddy.withPlugins {
  hash = "sha256-sY3LlHw85kV/a8Pjpc6J21cY3K8fqBq7KlMfAmyetH0=";
  plugins = [
    "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
    "github.com/caddy-dns/cloudflare@v0.2.2-0.20250506153119-35fb8474f57d"
  ];
}
