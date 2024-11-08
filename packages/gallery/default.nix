{ inputs
, stdenvNoCC
, lib
, nodejs
, pnpm_9
, nix-gitignore
, google-fonts
, defaultDomain ? "YSUN.LIFE"
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gallery";
  version = "unstable-${lib.concatStringsSep "-" [
  (lib.substring 0 4 inputs.gallery.lastModifiedDate)
  (lib.substring 4 2 inputs.gallery.lastModifiedDate)
  (lib.substring 6 2 inputs.gallery.lastModifiedDate)
]}";

  src = nix-gitignore.gitignoreSource [ ] inputs.gallery;

  patches = [ ./local-font.patch ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-yFrlRiwPOyrQ+NxjpFzX+XAoxQFVqPGjh4DCs7mdLm4=";
    preBuild = "echo 'strict-ssl=false' >> .npmrc";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  buildPhase = ''
    runHook preBuild

    echo "NEXT_PUBLIC_SITE_DOMAIN=${defaultDomain}" > .env
    cp "${google-fonts.override { fonts = [ "IBMPlexMono" ]; }}"/share/fonts/truetype/IBMPlexMono-{Regular,Bold,Medium}.ttf src/app/
    NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    ls -la .next

    cp -r .next/standalone $out/share/gallery/
    cp -r .env $out/share/gallery/
    cp -r public $out/share/gallery/public

    mkdir -p $out/share/gallery/.next
    cp -r .next/static $out/share/gallery/.next/static

    ln -s /var/cache/gallery $out/share/gallery/.next/cache

    runHook postInstall
  '';

  meta.broken = true;
})
