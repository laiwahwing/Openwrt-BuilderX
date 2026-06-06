#!/bin/bash
# Fix rkbin PKG_MIRROR_HASH mismatch when git fallback repacks sources.
set -euo pipefail

MAKEFILE="${BUILD_DIR:-openwrt}/package/boot/arm-trusted-firmware-rockchip/Makefile"

if [[ ! -f "$MAKEFILE" ]]; then
  exit 0
fi

sed -i \
  's/PKG_MIRROR_HASH:=4b801b1301ae297f660340617b5f398b23a3f0b43bc7f0ef42c21f0f43eb8990/PKG_MIRROR_HASH:=74f1f40a2ec7abbffd1f6ad5e7eb4aae4b227355dec846f93d8771e418dbfc41/' \
  "$MAKEFILE"
