#!/bin/bash
# Append third-party feeds required by configs/default.packages.txt.
set -euo pipefail

FEEDS_FILE="${BUILD_DIR:-openwrt}/feeds.conf.default"

if [[ ! -f "$FEEDS_FILE" ]]; then
  echo "Missing feeds file: $FEEDS_FILE"
  exit 1
fi

append_feed() {
  local name="$1" url="$2"
  if grep -qE "^src-git[[:space:]]+${name}([[:space:]]|$)" "$FEEDS_FILE"; then
    return 0
  fi
  echo "src-git $name $url" >> "$FEEDS_FILE"
}

append_feed passwall https://github.com/xiaorouji/openwrt-passwall
append_feed small https://github.com/kenzok8/small
