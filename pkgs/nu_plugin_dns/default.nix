{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_dns";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "nu_plugin_dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YMkefyXfM+l/6Fk1eGry/fxIahLQW6jQA6nQcQwQwtc=";
  };

  cargoHash = "sha256-p2RepMX/zk8ALT+gC8iu/S3tnHY43Pfql6/dBw1c0Oc=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  doCheck = false; # for now

  meta = {
    description = "DNS utility for nushell";
    mainProgram = "nu_plugin_dns";
    homepage = "https://github.com/dead10ck/nu_plugin_dns";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
})
