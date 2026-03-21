{ inputs
, lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, testers
, withUser ? "ripe-atlas"
, withGroup ? "ripe-atlas"
, withMeasurementUser ? "ripe-atlas-measurement"
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ripe-atlas-software-probe";
  version = "5120";

  src = fetchFromGitHub {
    owner = "ripe-ncc";
    repo = "ripe-atlas-software-probe";
    tag = finalAttrs.version;
    hash = "sha256-rjhLLeUj6US76/joRVBmYeqKsPVE5KzZGdE4eEilEKI=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  postPatch = ''
    # don't build the vendored busybox, measurement tools are packaged separately
    substituteInPlace Makefile.am \
      --replace-fail \
        "SUBDIRS = bin config probe-busybox/libevent-2.1.11-stable probe-busybox ." \
        "SUBDIRS = bin config ."
    substituteInPlace configure.ac \
      --replace-fail \
        "AC_CONFIG_SUBDIRS([probe-busybox/libevent-2.1.11-stable])" ""

    # remove install targets for busybox binary and runtime directory creation
    sed -i '/^install-exec-local:/,$d' Makefile.am

    # remove BUILT_SOURCES and CLEANFILES references to busybox header
    sed -i '/^BUILT_SOURCES/,/atlas_path\.h/d' config/Makefile.am
    sed -i '/probe-busybox/d' config/Makefile.am
    sed -i 's/common\/measurement\.conf \\/common\/measurement.conf/' config/Makefile.am

    # fix hardcoded paths for NixOS PATH-based resolution.
    # "command ssh" bypasses the ssh() shell function to call the real binary
    substituteInPlace bin/arch/linux/linux-functions.sh \
      --replace-fail '/usr/bin/ssh' 'command ssh' \
      --replace-fail "grep 'link\/ether'" "grep 'link/ether'" \
      --replace-fail '$ATLAS_LIBEXECDIR/ping' '$ATLAS_MEASUREMENT/ping' \
      --replace-fail '$ATLAS_LIBEXECDIR/ooqd' '$ATLAS_MEASUREMENT/ooqd'
    substituteInPlace bin/ripe-atlas.in \
      --replace-fail '/sbin/ifconfig' 'ifconfig' \
      --replace-fail 'cp $KNOWN_HOSTS_REG $ATLAS_STATUS/known_hosts' \
        'install -m 644 $KNOWN_HOSTS_REG $ATLAS_STATUS/known_hosts'

    # default to ed25519 instead of rsa for new probe keys
    substituteInPlace bin/arch/generic/generic-ATLAS.sh.in \
      --replace-fail 'ssh-keygen -t rsa' 'ssh-keygen -t ed25519'
  '';

  # make ATLAS_MEASUREMENT and ATLAS_SYSCONFDIR overridable via env so the
  # module can point them at the correct runtime locations
  postInstall = ''
    substituteInPlace $out/libexec/ripe-atlas/scripts/paths.lib.sh \
      --replace-fail 'ATLAS_MEASUREMENT=' 'ATLAS_MEASUREMENT=''${ATLAS_MEASUREMENT:-' \
      --replace-fail 'ATLAS_SYSCONFDIR=' 'ATLAS_SYSCONFDIR=''${ATLAS_SYSCONFDIR:-'
    sed -i '/^ATLAS_MEASUREMENT=/ s/$/ }/' $out/libexec/ripe-atlas/scripts/paths.lib.sh
    sed -i '/^ATLAS_SYSCONFDIR=/ s/$/ }/' $out/libexec/ripe-atlas/scripts/paths.lib.sh
  '';

  configureFlags = [
    "--disable-systemd"
    "--disable-chown"
    "--disable-setcap-install"
    "--localstatedir=/var"
    "--runstatedir=/run"
    "--with-user=${withUser}"
    "--with-group=${withGroup}"
    "--with-measurement-user=${withMeasurementUser}"
  ];

  passthru.tests.ripe-atlas-software-probe = testers.runNixOSTest (import ./test.nix { inherit inputs; });

  meta = {
    description = "RIPE Atlas Software Probe";
    homepage = "https://github.com/ripe-ncc/ripe-atlas-software-probe";
    platforms = lib.platforms.linux;
  };
})
