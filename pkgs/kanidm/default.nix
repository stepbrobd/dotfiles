{ kanidmWithSecretProvisioning_1_11 }:

kanidmWithSecretProvisioning_1_11.overrideAttrs (prev: {
  patches = prev.patches ++ [ ./custom-deployment.patch ];

  postPatch = (prev.postPatch or "") + ''
    cp ${./override.css} server/core/static/override.css
  '';

  __darwinAllowLocalNetworking = true;
})
