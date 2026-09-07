{ inputs, stdenv }:

# pull caddy from `inputs` directly to prevent infinite recursion
# as `caddy.withPlugins` is implemented with override
inputs.nixpkgs.legacyPackages.${stdenv.hostPlatform.system}.caddy.withPlugins {
  hash = "sha256-YKPsJo670Jbk6BUygkZ5cezR+D0r8IMS1P5dNuHucLQ=";
  plugins = [
    "github.com/caddy-dns/cloudflare@v0.2.4"
    "github.com/relvacode/caddy-oidc@v0.4.2"
    "github.com/stepbrobd/caddy-sigsci@v0.0.0-20260907213328-69680bbe90ee"
    "github.com/stepbrobd/certmagic-s3@v0.0.0-20260906102855-4c0666564d10"
    "github.com/ueffel/caddy-brotli@v1.6.0"
  ];
}
