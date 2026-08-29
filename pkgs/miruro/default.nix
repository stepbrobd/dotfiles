{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule (finalAttrs: {
  pname = "miruro";
  version = "2026.829.1";

  __structuredAttrs = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "miruro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N6dnaLRiqcHyIlROzkqZwMMbVK8V2932XM2HEsay63A=";
  };

  vendorHash = "sha256-Gam62PXQYAKGPjq9o3hV3omV8jH85/L/qM/uEcSXIjU=";

  ldflags = [ "-s" "-X main.version=${finalAttrs.version}" ];

  passthru.autobump = true;

  meta = {
    description = "Why u here weeb";
    homepage = "https://github.com/stepbrobd/miruro";
    changelog = "https://github.com/stepbrobd/miruro/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "miruro";
  };
})
