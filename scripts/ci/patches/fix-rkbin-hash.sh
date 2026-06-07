#!/bin/bash
# CI often builds rkbin via git archive instead of the mirror tarball.
# Mirror hash: 74f1f40...  Git archive hash: 4b801b...
set -euo pipefail

MAKEFILE="${BUILD_DIR:-openwrt}/package/boot/arm-trusted-firmware-rockchip/Makefile"
GIT_ARCHIVE_HASH=4b801b1301ae297f660340617b5f398b23a3f0b43bc7f0ef42c21f0f43eb8990

if [[ ! -f "$MAKEFILE" ]]; then
  exit 0
fi

sed -i "s/^PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=${GIT_ARCHIVE_HASH}/" "$MAKEFILE"
