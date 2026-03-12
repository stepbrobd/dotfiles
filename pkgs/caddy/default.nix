{ inputs, stdenv }:

# pull caddy from `inputs` directly to prevent infinite recursion
# as `caddy.withPlugins` is implemented with override
inputs.nixpkgs.legacyPackages.${stdenv.hostPlatform.system}.caddy.withPlugins {
  hash = "sha256-w0zoj67gFQExaI0Hu38jPLHQR6xh7FRDtpBrXQLJZFk=";
  plugins = [
    "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
    "github.com/caddy-dns/cloudflare@v0.2.3-0.20251204174556-6dc1fbb7e925"
    "github.com/relvacode/caddy-oidc@v0.3.0"
    "github.com/ss098/certmagic-s3@v0.0.0-20250922022452-8af482af5f39"
    "github.com/ueffel/caddy-brotli@v1.6.0"
  ];
}
