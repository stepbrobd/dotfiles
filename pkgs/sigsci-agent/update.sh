# shellcheck shell=bash

root="$(git rev-parse --show-toplevel)"
file="${root}/pkgs/sigsci-agent/default.nix"

changed=0

read_attr() {
  sed -n "s|^[[:space:]]*$1 = \"\([^\"]*\)\";.*|\1|p" "${file}" | head -n1
}

sync_attr() {
  local name="$1" want="$2" have
  have="$(read_attr "${name}")"
  if [ "${have}" = "${want}" ]; then
    return 0
  fi
  sed -i "s|^\([[:space:]]*\)${name} = \"[^\"]*\";|\1${name} = \"${want}\";|" "${file}"
  echo "sigsci-agent: ${name}: ${have:-<none>} -> ${want}"
  changed=1
}

# the download base and the systems come from default.nix
base="$(read_attr base)"
if [ -z "${base}" ]; then
  echo "sigsci-agent: could not read base from ${file}" >&2
  exit 1
fi

mapfile -t systems < <(sed -n '/^[[:space:]]*hashes = {/,/^[[:space:]]*};/p' "${file}" | sed -n 's|^[[:space:]]*\([a-z0-9_-]*\) = "[^"]*";.*|\1|p')
if [ "${#systems[@]}" -eq 0 ]; then
  echo "sigsci-agent: could not read hashes from ${file}" >&2
  exit 1
fi

suffix() {
  case "$1" in
    aarch64-*) printf '_arm64' ;;
    *) printf '' ;;
  esac
}

latest="$(curl -fsSL "${base}/VERSION" | tr -d '[:space:]')"
if ! [[ "${latest}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "sigsci-agent: unexpected VERSION ${latest:-<empty>}" >&2
  exit 1
fi

current="$(read_attr version)"
if [ "${latest}" = "${current}" ]; then
  echo "sigsci-agent: already at ${current}"
  exit 0
fi

# prefetch all systems before touching the file
declare -A hashes
for system in "${systems[@]}"; do
  url="${base}/${latest}/linux/sigsci-agent_${latest}$(suffix "${system}").tar.gz"
  hash="$(nix store prefetch-file --json "${url}" | jq -r '.hash')"
  if [ -z "${hash}" ] || [ "${hash}" = "null" ]; then
    echo "sigsci-agent: could not prefetch ${url}" >&2
    exit 1
  fi
  hashes[${system}]="${hash}"
done

sync_attr version "${latest}"
for system in "${systems[@]}"; do
  sync_attr "${system}" "${hashes[${system}]}"
done

if [ "${changed}" -eq 0 ]; then
  echo "sigsci-agent: already at ${latest}"
else
  echo "sigsci-agent: ${current} -> ${latest}"
fi
