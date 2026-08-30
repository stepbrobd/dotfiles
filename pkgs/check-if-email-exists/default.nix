# TODO: drop after https://github.com/NixOS/nixpkgs/pull/558032
{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "check-if-email-exists";
  version = "0.11.7";

  __structuredAttrs = true;

  passthru.autobump = true;

  src = fetchFromGitHub {
    owner = "reacherhq";
    repo = "check-if-email-exists";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KRnSTufgpmT6Yo+7NcaRARjtXOCwvbcXXX4or8YTmjo=";
  };

  cargoHash = "sha256-syuwY4qpnvWTXDZ6onnpFSmiEs1GCttSDtR5+vzuUDY=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  checkFlags = [
    "--skip=smtp::tests::should_timeout"
    "--skip=tests::test_input_foo_bar_baz"
  ];

  meta = {
    description = "Check if an email address exists without sending any email";
    homepage = "https://github.com/reacherhq/check-if-email-exists";
    changelog = "https://github.com/reacherhq/check-if-email-exists/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "check_if_email_exists";
  };
})
