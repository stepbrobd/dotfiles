{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_dns";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "nu_plugin_dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zf66C8YFS3pC5g24jh5mXhdSNoFDjGJSSWG1VSEZ4PM=";
  };

  cargoHash = "sha256-7qS1cXNuztVs6preUut0l/XZtsO7eAzdljst+mGBQnA=";

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
