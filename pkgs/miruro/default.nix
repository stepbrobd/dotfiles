{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule (finalAttrs: {
  pname = "miruro";
  version = "2026.823.0";

  __structuredAttrs = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "miruro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mlicmpChoQfg/L4ufCFvELDTMo8vGwaxuTkLaWfTm5w=";
  };

  vendorHash = "sha256-yik1WRYZUE+qXo49fR2eiAkjyP8OTTtTiFVEMQCo778=";

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
