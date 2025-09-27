{ rustPlatform
, verus
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vargo";
  inherit (verus) version src;

  sourceRoot = "${finalAttrs.src.name}/tools/vargo";
  cargoLock.lockFile = "${finalAttrs.src}/tools/vargo/Cargo.lock";
})
