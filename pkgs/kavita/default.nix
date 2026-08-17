{ lib, pkgsPrev }:

pkgsPrev.kavita.overrideAttrs (prev: {
  frontend = prev.frontend.overrideAttrs (prevFrontend: {
    postPatch = (prevFrontend.postPatch or "") + ''
      substituteInPlace src/index.html \
        --replace-fail '</head>' '<script defer data-domain="read.ysun.co" src="https://${lib.blueprint.services.plausible.domain}/js/script.file-downloads.hash.outbound-links.js"></script></head>'
    '';
  });
})
