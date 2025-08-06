{ pkgs }:

let
  inherit (pkgs.lib) sort lessThan toShellVar;
  plugins = [
    "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
    "github.com/caddy-dns/cloudflare@v0.2.2-0.20250724223520-f589a18c0f5d"
    "github.com/caddyserver/cache-handler@v0.16.0"
    "github.com/darkweak/storages/badger/caddy@v0.0.15"
    "github.com/ueffel/caddy-brotli@v1.6.0"
    "github.com/darkweak/souin=github.com/stepbrobd/souin@v0.0.0-20250806124142-bfe07621487a" # https://github.com/darkweak/souin/pull/657
  ];
  pluginsSorted = sort lessThan plugins;
in
(pkgs.caddy.withPlugins {
  inherit plugins;
  hash = "sha256-WwmsHQobTijOrZGZOwa+LgHKX2a0bs5C0H2onYd7HWU=";
}).overrideAttrs (_: _: {
  # https://github.com/NixOS/nixpkgs/pull/417247
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    ${toShellVar "notfound" pluginsSorted}

    local build_info_output
    build_info_output=$($out/bin/caddy build-info)

    print_common_advice() {
      echo "  - if you are using \`go.mod\` alias or other advanced usage(s), set \`doInstallCheck = false\` or write your own \`installCheckPhase\` in \`caddy.withPlugins\` call"
      echo "  - if you are sure this error is caused by packaging, or caused by caddy/xcaddy, raise an issue with nixpkgs or upstream"
    }

    while read -r kind module version rest; do
      if [[ "$kind" != "dep" && "$kind" != "=>" ]]; then
        continue
      fi

      if [[ -z "$module" || -z "$version" ]]; then
        continue
      fi

      local module_from_build="''${module}@''${version}"

      for i in "''${!notfound[@]}"; do
        local user_plugin="''${notfound[i]}"
        local expected_in_build="$user_plugin"

        if [[ "$user_plugin" == *"="* ]]; then
          expected_in_build="''${user_plugin#*=}"
        fi

        if [[ "$expected_in_build" == "$module_from_build" ]]; then
          unset 'notfound[i]'
          break
        fi
      done
    done < <(echo "$build_info_output")

    if (( ''${#notfound[@]} )); then
      for plugin in "''${notfound[@]}"; do
        if [[ "$plugin" == *"="* ]]; then
          echo "Plugin with alias \"$plugin\" not found in build:"
          echo "  The check looks for the replacement module \"''${plugin#*=}\" in the build output."
          echo "  This replacement module was not found:"
          print_common_advice
        else
          local base=''${plugin%@*}
          local specified=''${plugin#*@}
          local found=0

          while read -r kind module expected rest; do
            if [[ ("$kind" = "dep" || "$kind" = "=>") && "$module" = "$base" ]]; then
              echo "Plugin \"$base\" have incorrect tag:"
              echo "  specified: \"$base@$specified\""
              echo "  got: \"$base@$expected\""
              found=1
              break
            fi
          done < <(echo "$build_info_output")

          if (( found == 0 )); then
            echo "Plugin \"$base\" not found in build:"
            echo "  specified: \"$base@$specified\""
            echo "  plugin does not exist in the xcaddy build output:"
            print_common_advice
          fi
        fi
      done

      exit 1
    fi

    runHook postInstallCheck
  '';
})
