{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchpatch
, installShellFiles
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cfspeedtest";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = "cfspeedtest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q1K5UcrSckEN+6W9UO2u07R3mZ6+J8E1ZYRZqnXif1s=";
  };

  patches = [
    (fetchpatch {
      name = "bind-address.patch";
      url = "https://github.com/code-inflation/cfspeedtest/commit/8472200bca58e4d5713c400c74557e1ee3a01a11.patch";
      hash = "sha256-vACWUjoTQqRPzsbTDAauzRU9MvkdyfaBvv+kH1gHkhw=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-moYovJamW9xX3niO10bG9K3choDMV3wtuUSCn/5g1Yw=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cfspeedtest \
      --bash <($out/bin/cfspeedtest --generate-completion bash) \
      --fish <($out/bin/cfspeedtest --generate-completion fish) \
      --zsh <($out/bin/cfspeedtest --generate-completion zsh)
  '';

  meta = {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    mainProgram = "cfspeedtest";
  };
})
