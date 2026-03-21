{ pkgsPrev, fetchFromGitHub }:

(pkgsPrev.tailscale.override {
  buildGoModule = pkgsPrev.buildGoModule.override {
    go = pkgsPrev.go_1_26.overrideAttrs {
      version = "1.26.1";

      src = fetchFromGitHub {
        owner = "tailscale";
        repo = "go";
        rev = "5cce30e20c1fc6d8463b0a99acdd9777c4ad124b";
        hash = "sha256-nYXUQfKPoHgKCvK5BCh0BKOgPh6n90XX+iUNETLETBA=";
      };
    };
  };
}).overrideAttrs {
  version = "1.97.58+18781";

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "tailscale";
    rev = "7114ae93ca6f02232efa783a54eb390efdb7cdc4";
    hash = "sha256-t8Ix0TtY/Bo51/8UDVRzgBpr4rt23Sz4OK74XijKxP0=";
  };

  vendorHash = "sha256-39axT5Q0+fNTcMgZCMLMNfJEJN46wMaaKDgfI+Uj+Ps=";
}
