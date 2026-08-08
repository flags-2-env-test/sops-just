#!/usr/bin/env bash
set -euo pipefail

install_dir="${1:-/usr/local/bin}"
mkdir -p "$install_dir"

case "$(uname -s)-$(uname -m)" in
  Linux-x86_64)
    ;;
  *)
    echo "install-tools.sh currently certifies Linux x86_64 only" >&2
    exit 2
    ;;
esac

SOPS_VERSION=3.13.3
SOPS_SHA256=e5bec3346a873ae91d871550f3e698c1aad962aff462a080e40f25fde17fef6b
JUST_VERSION=1.58.0
JUST_SHA256=4a5cc2f53e6f0f8c59092a6cc38291eb729d46a7dd95d3ae582008881b84931d

work="$(mktemp -d "${TMPDIR:-/tmp}/sops-just-tools.XXXXXX")"
trap 'rm -rf -- "$work"' EXIT HUP INT TERM

curl -fsSL --retry 5 \
  "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64" \
  -o "$work/sops"
printf '%s  %s\n' "$SOPS_SHA256" "$work/sops" | sha256sum -c - >/dev/null
install -m 0755 "$work/sops" "$install_dir/sops"

curl -fsSL --retry 5 \
  "https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-x86_64-unknown-linux-musl.tar.gz" \
  -o "$work/just.tar.gz"
printf '%s  %s\n' "$JUST_SHA256" "$work/just.tar.gz" | sha256sum -c - >/dev/null
tar -xzf "$work/just.tar.gz" -C "$work"
install -m 0755 "$work/just" "$install_dir/just"

"$install_dir/sops" --version >/dev/null
"$install_dir/just" --version >/dev/null
