{ lib, pkgsPrev }:

pkgsPrev.grafana.overrideAttrs (prev: {
  postPatch = prev.postPatch + ''
    cp ${./nord.json} packages/grafana-data/src/themes/themeDefinitions/nord.json

    substituteInPlace packages/grafana-data/src/themes/registry.ts \
      --replace-fail \
        "import zen from './themeDefinitions/zen.json';" \
        "import nord from './themeDefinitions/nord.json'; import zen from './themeDefinitions/zen.json';" \
      --replace-fail \
        "  zen," \
        "  nord, zen,"

    substituteInPlace public/app/core/components/ThemeSelector/getSelectableThemes.ts \
      --replace-fail \
        "    'gloom'," \
        "    'gloom', 'nord',"
  '';

  preFixup = with lib.blueprint.services; ''
    substituteInPlace $out/share/grafana/public/views/index.html \
      --replace-fail '</head>' '<script defer data-domain="${grafana.domain}" src="https://${plausible.domain}/js/script.file-downloads.hash.outbound-links.js"></script></head>'
  '';
})
