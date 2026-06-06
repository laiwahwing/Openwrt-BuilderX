#!/bin/bash
# Optional hook: runs in repo root after .config is copied, before make defconfig.
# Customize per device or keep shared tweaks here.

set -euo pipefail

OPENWRT_DIR="${BUILD_DIR:-openwrt}"
CONFIG_FILE="${OPENWRT_DIR}/.config"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "post-config: $CONFIG_FILE not found"
  exit 1
fi

# Example: override preinit IP for all builds using this hook.
# sed -ri 's/CONFIG_TARGET_PREINIT_IP=.+/CONFIG_TARGET_PREINIT_IP=10.12.20.1/' "$CONFIG_FILE"
# sed -ri 's/CONFIG_TARGET_PREINIT_BROADCAST=.+/CONFIG_TARGET_PREINIT_BROADCAST=10.12.20.255/' "$CONFIG_FILE"
