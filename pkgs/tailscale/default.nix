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
  version = "1.97.8+18781";

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "tailscale";
    rev = "f63409efd18ade1310f36472337e17da8aaba48d";
    hash = "sha256-EtcfInOnRGwvI3Ka3caY9juxj2YsFYUNSNnOlMitHW0=";
  };

  vendorHash = "sha256-dx+SJyDx+eZptFaMatoyM6w1E3nJKY+hKs7nuR997bE=";
}
