#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FONT_DIR="${1:?Usage: update-fonts.sh <font-directory>}"

tar cJf - -C "$FONT_DIR" . \
    | age -r "$(grep recipient "$SCRIPT_DIR/.chezmoi.toml.tmpl" | cut -d'"' -f2)" \
    -o "$SCRIPT_DIR/fonts/fonts.tar.xz.age"

echo "Updated fonts/fonts.tar.xz.age from $FONT_DIR"
