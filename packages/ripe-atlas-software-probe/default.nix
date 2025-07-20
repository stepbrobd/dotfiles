{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, openssl
, pkg-config
, withUser ? "ripe-atlas"
, withGroup ? "ripe-atlas"
, withMeasurementUser ? "ripe-atlas-measurement"
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ripe-atlas-software-probe";
  version = "5110";

  src = fetchFromGitHub {
    owner = "ripe-ncc";
    repo = "ripe-atlas-software-probe";
    tag = finalAttrs.version;
    hash = "sha256-PH4mdz7OGYpS5KwXVbH7PV+DI3y8MG7uzXXMKnGrJ24=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ openssl ];

  env.NIX_CFLAGS_COMPILE = lib.toString [
    "-Wno-error=format-security"
    "-Wno-error=implicit-function-declaration"
  ];

  configureFlags = [
    "--enable-systemd"
    "--disable-chown"
    "--disable-setcap-install"
    "--prefix=${lib.placeholder "out"}"
    "--libdir=${lib.placeholder "out"}/lib"
    "--sysconfdir=${lib.placeholder "out"}/etc"
    "--localstatedir=${lib.placeholder "out"}/var"
    "--runstatedir=/run"
    "--with-user=${withUser}"
    "--with-group=${withGroup}"
    "--with-measurement-user=${withMeasurementUser}"
  ];

  preBuild = ''
    sed -i '/install-exec-local:/,/^$/d' Makefile
  '';

  meta = {
    broken = true;
    platforms = lib.platforms.linux;
  };
})
