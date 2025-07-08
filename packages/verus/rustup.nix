{ writeShellScriptBin, toolchainName }:

writeShellScriptBin "rustup" ''
  set -eu -o pipefail

  args="$@"

  die() {
    echo "unexpected args: $args" >&2
    exit 1
  }

  [ "$1" == "show" ] || die
  shift

  [ "$1" == "active-toolchain" ] || die
  shift

  echo "${toolchainName}"
''
