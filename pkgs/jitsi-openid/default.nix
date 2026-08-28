{ rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jitsi-openid";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "MarcelCoding";
    repo = "jitsi-openid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s/b70kmv8N85Ri26B0k8jsqnvIBMxDo4iOCT1xjmCw0=";
  };

  cargoHash = "sha256-O7ZzGNvmwGKiUSWRboYj0ukKSr8RTvn34nbnOXtWkPs=";

  passthru.autobump = true;

  meta.mainProgram = "jitsi-openid";
})
