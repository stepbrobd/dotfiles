{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, sqlite
}:

rustPlatform.buildRustPackage {
  pname = "migrate-matrix";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tilosp";
    repo = "migrate-matrix";
    rev = "03ffe9d314f871cbcc3b2729aa2e5872d4b39c31";
    hash = "sha256-/lNeTqfQDZ6HRDdWci/PU+8yZ1UVLf6Kghm0sENATPM=";
  };

  cargoHash = "sha256-hjVLHuIXKxeCTNvxAy+wt1zgrqewSYVzhnEUDvcv6bo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl sqlite ];

  meta = {
    description = "A tool to migrate Matrix accounts between servers";
    homepage = "https://github.com/tilosp/migrate-matrix";
    license = lib.licenses.asl20;
    mainProgram = "migrate-matrix";
  };
}
