{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, openssl
, pkg-config
, ripe-atlas-software-probe
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ripe-atlas-probe-measurements";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "ripe-ncc";
    repo = "ripe-atlas-probe-measurements";
    tag = finalAttrs.version;
    hash = "sha256-TCbkbem1CSKPwt3S4fjGoklBf/qKNZkiEmI4yDJgwzQ=";
  };

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];
  buildInputs = [ openssl ];

  env.NIX_CFLAGS_COMPILE = lib.toString [
    "-Wno-error=format-security"
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=incompatible-pointer-types"
    "-Wno-error=return-type"
    "-Wno-error=int-conversion"
  ];

  postPatch =
    let
      probe = ripe-atlas-software-probe;
    in
    ''
          cat > include/atlas_path.h <<HEADER
      #ifndef _ATLAS_PATH_H_
      #define _ATLAS_PATH_H_
      #define ATLAS_LIBEXECDIR  "${probe}/libexec/ripe-atlas"
      #define ATLAS_DATADIR     "${probe}/share/ripe-atlas"
      #define ATLAS_SYSCONFDIR  "${probe}/etc/ripe-atlas"
      #define ATLAS_SPOOLDIR    "/var/spool/ripe-atlas"
      #define ATLAS_RUNDIR      "/run/ripe-atlas"
      #define ATLAS_MEASUREMENT "$out/libexec/ripe-atlas/measurement"
      #define ATLAS_SCRIPTS     "${probe}/libexec/ripe-atlas/scripts"
      #define ATLAS_TMP         "/tmp"
      #define ATLAS_CRONS       "/var/spool/ripe-atlas/crons"
      #define ATLAS_DATA        "/var/spool/ripe-atlas/data"
      #define ATLAS_PIDS        "/run/ripe-atlas/pids"
      #define ATLAS_STATUS      "/run/ripe-atlas/status"
      #endif
      HEADER
    '';

  dontConfigure = true;

  preBuild = ''
    pushd libevent-2.1.11-stable
    autoreconf --install
    ./configure --prefix=$PWD/../atlas --disable-shared --enable-static
    make -j$NIX_BUILD_CORES
    make install
    popd

    make silentoldconfig
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 busybox $out/libexec/ripe-atlas/measurement/busybox

    # create applet symlinks in the measurement dir (shell scripts use $ATLAS_MEASUREMENT/<tool>)
    # and in bin/ (for PATH resolution)
    mkdir -p $out/bin
    make busybox.links
    while IFS= read -r link; do
      ln -sf busybox "$out/libexec/ripe-atlas/measurement/$(basename "$link")"
      ln -sf $out/libexec/ripe-atlas/measurement/busybox "$out/bin/$(basename "$link")"
    done < busybox.links

    runHook postInstall
  '';

  meta = {
    description = "RIPE Atlas probe measurement tools";
    homepage = "https://github.com/ripe-ncc/ripe-atlas-probe-measurements";
    platforms = lib.platforms.linux;
  };
})
