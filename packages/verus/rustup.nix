{ writeShellScriptBin, toolchainName }:

writeShellScriptBin "rustup" ''
  set -eu -o pipefail

  die() {
    echo "unexpected args: $*" >&2
    exit 1
  }

  if ([ "$1" == "show" ] && [ "$2" == "active-toolchain" ]) || ([ "$1" == "toolchain" ] && [ "$2" == "list" ]); then
    echo "${toolchainName}"
  elif [ "$1" == "run" ] && [ "$2" == "${toolchainName}" ] && [ "$3" == "--" ]; then
    shift 3
    exec "$@"
  else
    die
  fi
''
