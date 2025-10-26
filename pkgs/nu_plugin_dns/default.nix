{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_dns";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "nu_plugin_dns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/f6ccLD2MUJx1S5wSQNaC8vDFCnomAXT/t+aQryNr6k=";
  };

  cargoHash = "sha256-E92ViE0FvSMA5HdRZN99bjHbxezvkZyb+mRSSgopu9s=";

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
