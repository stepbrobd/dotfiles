{ pkgs }:

let
  inherit (pkgs.lib) sort lessThan toShellVar;
  plugins = [
    "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
    "github.com/caddy-dns/cloudflare@v0.2.2-0.20250724223520-f589a18c0f5d"
    "github.com/caddyserver/cache-handler@v0.16.0"
    "github.com/darkweak/storages/badger/caddy@v0.0.15"
    "github.com/ueffel/caddy-brotli@v1.6.0"
    "github.com/darkweak/souin=github.com/darkweak/souin@v1.7.8-0.20250812092955-b2a08bf1141e"
  ];
  pluginsSorted = sort lessThan plugins;
in
(pkgs.caddy.withPlugins {
  inherit plugins;
  hash = "sha256-9tNj477aHLvlS8PdG0bmDKPqmH/x1PEkog3w4LWW1Jk=";
}).overrideAttrs (_: _: {
  # https://github.com/NixOS/nixpkgs/pull/433072
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    declare -A modules errors
    ${toShellVar "notfound" pluginsSorted}

    # put build info that we care about into `modules` list
    while read -r kind module version _; do
      case "$kind" in
        'dep'|'=>')
          modules[$module]=$version
          ;;
        *)
          # we only care about 'dep' and '=>' directives for now
          ;;
      esac
    done < <($out/bin/caddy build-info)

    # compare build-time (Nix side) against runtime (Caddy side)
    for spec in "''${notfound[@]}"; do
      if [[ $spec == *=* ]]; then
          # orig=repl_mod@repl_ver
          orig=''${spec%%=*}
          repl=''${spec#*=}
          repl_mod=''${repl%@*}
          repl_ver=''${repl#*@}

          if [[ -z ''${modules[$orig]} ]]; then
              errors[$spec]="plugin \"$spec\" with replacement not found in build info:\n  reason: \"$orig\" missing"
          elif [[ -z ''${modules[$repl_mod]} ]]; then
              errors[$spec]="plugin \"$spec\" with replacement not found in build info:\n  reason: \"$repl_mod\" missing"
          elif [[ "''${modules[$repl_mod]}" != "$repl_ver" ]]; then
              errors[$spec]="plugin \"$spec\" have incorrect tag:\n  specified: \"$spec\"\n  got: \"$orig=$repl_mod@''${modules[$repl_mod]}\""
          fi
      else
        # mod@ver
        mod=''${spec%@*}
        ver=''${spec#*@}

        if [[ -z ''${modules[$mod]} ]]; then
            errors[$spec]="plugin \"$spec\" not found in build info"
        elif [[ "''${modules[$mod]}" != "$ver" ]]; then
            errors[$spec]="plugin \"$spec\" have incorrect tag:\n  specified: \"$spec\"\n  got: \"$mod@''${modules[$mod]}\""
        fi
      fi
    done

    # print errors if any
    if [[ ''${#errors[@]} -gt 0 ]]; then
      for spec in "''${!errors[@]}"; do
        printf "Error: ''${errors[$spec]}\n" >&2
      done

      echo "Tips:"
      echo "If:"
      echo "  - you are using module replacement (e.g. \`plugin1=plugin2@version\`)"
      echo "  - the provided Caddy plugin is under a repository's subdirectory, and \`go.{mod,sum}\` files are not in that subdirectory"
      echo "  - you have custom build logic or other advanced use cases"
      echo "Please consider:"
      echo "  - set \`doInstallCheck = false\`"
      echo "  - write your own \`installCheckPhase\` and override the default script"
      echo "If you are sure this error is caused by packaging, or by caddy/xcaddy, raise an issue with upstream or nixpkgs"

      exit 1
    fi

    runHook postInstallCheck
  '';
})
