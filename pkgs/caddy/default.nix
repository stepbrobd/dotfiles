{ inputs, stdenv }:

# pull caddy from `inputs` directly to prevent infinite recursion
# as `caddy.withPlugins` is implemented with override
inputs.nixpkgs.legacyPackages.${stdenv.hostPlatform.system}.caddy.withPlugins {
  hash = "sha256-kP3gpVdLrAico5DIkitGgc4fekwqZu09S7/by06mgko=";
  plugins = [
    "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
    "github.com/caddy-dns/cloudflare@v0.2.4"
    "github.com/relvacode/caddy-oidc@v0.4.0"
    "github.com/stepbrobd/certmagic-s3@v0.0.0-20260824195825-3df4eadafe7e"
    "github.com/ueffel/caddy-brotli@v1.6.0"
  ];
}
