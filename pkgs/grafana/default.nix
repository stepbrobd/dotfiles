{ lib, pkgsPrev }:

pkgsPrev.grafana.overrideAttrs {
  preFixup = with lib.blueprint.services; ''
    substituteInPlace $out/share/grafana/public/views/index.html \
      --replace-fail '</head>' '<script defer data-domain="${grafana.domain}" src="https://${plausible.domain}/js/script.file-downloads.hash.outbound-links.js"></script></head>'
  '';
}
