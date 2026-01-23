{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_dns";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "nu_plugin_dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kadka38te8F0GFbnni3Oc6cdxHAS+yGtukZdPxbkmIA=";
  };

  cargoHash = "sha256-MZt3u28KZeahdRzeLxSESmYVFHZ38tCuJAR0kHPXW58=";

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
