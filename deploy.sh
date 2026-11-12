#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

REMOTE="darius@139.162.119.111"
DEST="/var/www/cocobook/"

if ! command -v hugo >/dev/null 2>&1; then
  echo "❌ 找不到 hugo，請先安裝（預期路徑：$HOME/.local/bin/hugo）" >&2
  exit 1
fi

echo "==> 建置（hugo --minify）"
hugo --minify --cleanDestinationDir

echo "==> 同步到 ${REMOTE}:${DEST}"
rsync -az --delete public/ "${REMOTE}:${DEST}"

echo "✅ 已部署到 https://cocobook.cc/"
