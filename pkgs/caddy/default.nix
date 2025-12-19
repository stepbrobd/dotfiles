{ inputs, stdenv }:

# pull caddy from `inputs` directly to prevent infinite recursion
# as `caddy.withPlugins` is implemented with override
inputs.nixpkgs.legacyPackages.${stdenv.hostPlatform.system}.caddy.withPlugins {
  hash = "sha256-NEtEjwdfRqz1j7wd886KCdMog5kbDR2qHB2z9+ZeBPU=";
  plugins = [
    "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
    "github.com/caddy-dns/cloudflare@v0.2.3-0.20251204174556-6dc1fbb7e925"
    "github.com/caddyserver/cache-handler@v0.16.0"
    "github.com/darkweak/souin@v1.7.8"
    "github.com/darkweak/storages/badger/caddy@v0.0.15"
    "github.com/ss098/certmagic-s3@v0.0.0-20250922022452-8af482af5f39"
    "github.com/tailscale/caddy-tailscale@v0.0.0-20251204171825-f070d146dd61"
    "github.com/ueffel/caddy-brotli@v1.6.0"
  ];
}
