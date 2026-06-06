#!/bin/bash
# Apply configs/default.packages.txt on top of a device defconfig.
# Usage: apply-default-packages.sh <device>
#   device: mt2500 | mt6000 | easepi

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PACKAGES_FILE="${ROOT}/configs/default.packages.txt"
DEVICE="${1:-}"

declare -A TARGET_SEED=(
  [mt2500]="CONFIG_TARGET_mediatek=y
CONFIG_TARGET_mediatek_filogic=y
CONFIG_TARGET_mediatek_filogic_DEVICE_glinet_gl-mt2500-airoha=y"
  [mt6000]="CONFIG_TARGET_mediatek=y
CONFIG_TARGET_mediatek_filogic=y
CONFIG_TARGET_mediatek_filogic_DEVICE_glinet_gl-mt6000=y"
  [easepi]="CONFIG_TARGET_rockchip=y
CONFIG_TARGET_rockchip_armv8=y
CONFIG_TARGET_rockchip_armv8_DEVICE_linkease_easepi-r1=y"
)

if [[ -z "$DEVICE" || -z "${TARGET_SEED[$DEVICE]:-}" ]]; then
  echo "Usage: $0 <mt2500|mt6000|easepi>"
  exit 1
fi

if [[ ! -f "$PACKAGES_FILE" ]]; then
  echo "Missing $PACKAGES_FILE"
  exit 1
fi

mapfile -t EXTRA_PACKAGES < <(
  awk '
    /^## / { section=substr($0,4); next }
    /^[[:space:]]*$/ { next }
    /^#/ { next }
    { print }
  ' "$PACKAGES_FILE"
)

if ((${#EXTRA_PACKAGES[@]} == 0)); then
  echo "No packages found in $PACKAGES_FILE"
  exit 1
fi

cd "$ROOT"

{
  echo "CONFIG_MODULES=y"
  echo "CONFIG_HAVE_DOT_CONFIG=y"
  echo "${TARGET_SEED[$DEVICE]}"
} > .config

make defconfig >/dev/null

for pkg in "${EXTRA_PACKAGES[@]}"; do
  if ./scripts/config -q "CONFIG_PACKAGE_${pkg}" 2>/dev/null; then
    ./scripts/config --set "CONFIG_PACKAGE_${pkg}=y" 2>/dev/null || true
  else
    echo "CONFIG_PACKAGE_${pkg}=y" >> .config
  fi
done

make defconfig >/dev/null

cp .config "${ROOT}/configs/${DEVICE}.config"
echo "Wrote ${ROOT}/configs/${DEVICE}.config"
