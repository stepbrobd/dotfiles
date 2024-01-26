# https://mdleom.com/blog/2021/12/27/caddy-plugins-nixos
# https://noah.masu.rs/posts/caddy-cloudflare-dns

{ stdenv
, lib
, pkgs
, plugins ? [ ]
, ...
}:

stdenv.mkDerivation {
  # __impure = true;

  pname = "pcaddy";
  version = "${pkgs.caddy.version}";

  dontUnpack = true;

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
  '';

  nativeBuildInputs = with pkgs; [ git go xcaddy ];

  buildPhase =
    let
      pluginArgs = lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
    in
    ''
      runHook preBuild
      ${pkgs.xcaddy}/bin/xcaddy build v${pkgs.caddy.version} ${pluginArgs}
      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv caddy $out/bin
    runHook postInstall
  '';

  meta.mainProgram = "caddy";
}
