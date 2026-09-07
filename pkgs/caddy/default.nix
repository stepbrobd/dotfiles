{ inputs, stdenv }:

# pull caddy from `inputs` directly to prevent infinite recursion
# as `caddy.withPlugins` is implemented with override
inputs.nixpkgs.legacyPackages.${stdenv.hostPlatform.system}.caddy.withPlugins {
  hash = "sha256-BxMtZA5qg7cGBbT6vI6IGJmqNc99+IIOCugJYU9DTu4=";
  plugins = [
    "github.com/caddy-dns/cloudflare@v0.2.4"
    "github.com/relvacode/caddy-oidc@v0.4.2"
    "github.com/stepbrobd/caddy-sigsci@v0.0.0-20260907205609-01b8e8552cb2"
    "github.com/stepbrobd/certmagic-s3@v0.0.0-20260906102855-4c0666564d10"
    "github.com/ueffel/caddy-brotli@v1.6.0"
  ];
}
