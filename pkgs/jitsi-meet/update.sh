#!/usr/bin/env bash
set -euo pipefail

if (( $# != 1 )); then
  echo "usage: $0 <jitsi-meet>" >&2
  exit 2
fi

component=$1
file="pkgs/$component/default.nix"
cd "$(git rev-parse --show-toplevel)"

index=$(curl --fail --silent --show-error https://download.jitsi.org/stable/Packages)

latest() {
  awk -v package="$1" '
    $0 == "Package: " package { found = 1; next }
    found && /^Version: / { print $2; found = 0 }
  ' <<<"$index" | sort -V | tail -n 1
}

pin() {
  local dependency=$1 depends value

  depends=$(
    awk -v version="$(latest jitsi-meet)" '
      $0 == "Package: jitsi-meet" { package = 1; next }
      package && $0 == "Version: " version { release = 1; next }
      release && /^Depends: / { print; exit }
      /^$/ { package = 0; release = 0 }
    ' <<<"$index"
  )

  if [[ $depends != *"$dependency (= "* ]]; then
    echo "$dependency is not pinned by the latest jitsi-meet package" >&2
    return 1
  fi

  value=${depends#*"$dependency (= "}
  value=${value%%)*}
  printf '%s\n' "${value%-1}"
}

case $component in
  jitsi-meet)
    version=$(pin jitsi-meet-web)
    url="https://download.jitsi.org/jitsi-meet/src/jitsi-meet-${version}.tar.bz2"
    ;;
  *)
    echo "unknown component: $component" >&2
    exit 2
    ;;
esac

if [[ -z $version ]]; then
  echo "version not found for $component" >&2
  exit 1
fi

current=$(awk -F '"' '/^[[:space:]]*version = "/ { print $2; exit }' "$file")
if [[ -z $current ]]; then
  echo "version not found in $file" >&2
  exit 1
fi

if [[ $current == "$version" ]]; then
  echo "$component: $version is current"
  exit 0
fi

hash=$(nix store prefetch-file --json "$url" | jq --exit-status --raw-output .hash)
sed -i -e "s|version = \"$current\";|version = \"$version\";|" \
  -e "s|hash = \"sha256-[^\"]*\";|hash = \"$hash\";|" "$file"
echo "$component: $current -> $version"
