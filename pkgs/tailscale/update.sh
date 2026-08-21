# shellcheck shell=bash

owner="tailscale"
repo="tailscale"
branch="main"

root="$(git rev-parse --show-toplevel)"
file="${root}/pkgs/tailscale/default.nix"

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
  echo "tailscale: ${name}: ${have:-<none>} -> ${want}"
  changed=1
}

require() {
  if [ -z "$2" ] || [ "$2" = "null" ]; then
    echo "tailscale: could not read $1 at ${latest}" >&2
    exit 1
  fi
}

latest="$(git ls-remote "https://github.com/${owner}/${repo}.git" "refs/heads/${branch}" | cut -f1)"
if [ -z "${latest}" ]; then
  echo "tailscale: could not resolve ${owner}/${repo}@${branch}" >&2
  exit 1
fi

work="$(mktemp -d)"
trap 'chmod -R +w "${work}" 2>/dev/null || true; rm -rf "${work}" 2>/dev/null || true' EXIT
git clone --quiet --filter=blob:none --no-checkout "https://github.com/${owner}/${repo}.git" "${work}/src"
src="${work}/src"

hashes="$(git -C "${src}" show "${latest}:flakehashes.json")"
goVersion="$(git -C "${src}" show "${latest}:go.toolchain.version" | tr -d '[:space:]')"
goRev="$(printf '%s' "${hashes}" | jq -r '.toolchain.rev')"
goHash="$(printf '%s' "${hashes}" | jq -r '.toolchain.sri')"
vendorHash="$(printf '%s' "${hashes}" | jq -r '.vendor.sri')"

require goVersion "${goVersion}"
require goRev "${goRev}"
require goHash "${goHash}"
require vendorHash "${vendorHash}"

if [ "${latest}" = "$(read_attr tsRev)" ]; then
  tsVersion="$(read_attr tsVersion)"
  tsHash="$(read_attr tsHash)"
else
  base="$(git -C "${src}" rev-list --max-count=1 "${latest}" -- VERSION.txt)"
  if [ -z "${base}" ]; then
    echo "tailscale: could not find a commit touching VERSION.txt under ${latest}" >&2
    exit 1
  fi
  IFS=. read -r major minor patch _ <<< "$(git -C "${src}" show "${base}:VERSION.txt")"
  if [ -z "${major}" ] || [ -z "${minor}" ]; then
    echo "tailscale: could not parse VERSION.txt at ${base}" >&2
    exit 1
  fi
  if (( minor % 2 == 1 )); then
    patch="$(git -C "${src}" rev-list --count "${latest}" "^${base}")"
  fi
  tsVersion="${major}.${minor}.${patch:-0}"

  tsHash="$(nix-prefetch-github "${owner}" "${repo}" --rev "${latest}" | jq -r '.hash')"
fi

require tsVersion "${tsVersion}"
require tsHash "${tsHash}"

sync_attr goVersion "${goVersion}"
sync_attr goRev "${goRev}"
sync_attr goHash "${goHash}"
sync_attr tsVersion "${tsVersion}"
sync_attr tsRev "${latest}"
sync_attr tsHash "${tsHash}"
sync_attr vendorHash "${vendorHash}"

if [ "${changed}" -eq 0 ]; then
  echo "tailscale: already at ${latest} (version ${tsVersion}, go ${goVersion})"
else
  echo "tailscale: now at ${latest} (version ${tsVersion}, go ${goVersion})"
fi
