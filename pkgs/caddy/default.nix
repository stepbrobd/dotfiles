{ inputs, stdenv }:

# pull caddy from `inputs` directly to prevent infinite recursion
# as `caddy.withPlugins` is implemented with override
inputs.nixpkgs.legacyPackages.${stdenv.hostPlatform.system}.caddy.withPlugins {
  hash = "sha256-Olvaar6yOtFGxpb/7rWAukkGxzUHcZuxGyoblmh+Y7w=";
  plugins = [
    "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
    "github.com/caddy-dns/cloudflare@v0.2.4"
    "github.com/relvacode/caddy-oidc@v0.3.1"
    "github.com/stepbrobd/certmagic-s3@v0.0.0-20260824190408-591008b07aa5"
    "github.com/ueffel/caddy-brotli@v1.6.0"
  ];
}
