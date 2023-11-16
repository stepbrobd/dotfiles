#!/usr/bin/env nix-shell
#!nix-shell -i bash -p google-cloud-sdk jq nix-output-monitor

set -euo pipefail

for arg in "$@"; do
  case $arg in
    -f=*|--format=*)
      FORMAT="${arg#*=}"
      shift
      ;;
    -m=*|--machine=*)
      MACHINE="${arg#*=}"
      shift
      ;;
    *)
      ;;
  esac
done

IMAGE_PLATFORM=$(nix eval --json .#nixosConfigurations.$MACHINE.pkgs.hostPlatform.system | jq -r '.')
IMAGE_VERSION=$(nix eval --json .#nixosConfigurations.$MACHINE.config.system.nixos.version | jq -r '.')
IMAGE_LABEL=$(nix eval --json .#nixosConfigurations.$MACHINE.config.networking.fqdnOrHostName | jq -r '.')
IMAGE_TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
IMAGE_NAME=$(echo nixos-$IMAGE_PLATFORM-$IMAGE_VERSION-$IMAGE_LABEL-$IMAGE_TIMESTAMP | tr '[:upper:]' '[:lower:]')

printf "Creating $IMAGE_NAME...\n"
nom build .#nixosConfigurations.$MACHINE.config.formats.$FORMAT -o $IMAGE_NAME
IMAGE_PATH=$(realpath $IMAGE_NAME)
printf "Created $IMAGE_PATH\n"
