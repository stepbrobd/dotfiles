# https://mdleom.com/blog/2021/12/27/caddy-plugins-nixos

{ stdenv
, lib
, pkgs
, plugins
, ...
}:

stdenv.mkDerivation {
  pname = "xcaddy";
  version = "latest";
  dontUnpack = true;

  nativeBuildInputs = with pkgs; [ git go xcaddy ];

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
  '';

  buildPhase =
    let
      pluginArgs = lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
    in
    ''
      runHook preBuild
      ${pkgs.xcaddy}/bin/xcaddy build latest ${pluginArgs}
      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv caddy $out/bin
    runHook postInstall
  '';
}
