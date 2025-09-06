#!/usr/bin/env bash
set -euo pipefail

PREFIX=${1:-/usr/local}

if [ "$(id -u)" -ne 0 ]; then
  echo "This installer needs root privileges. Run with sudo." >&2
  exit 1
fi

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing cvc5 artifacts to $PREFIX"

install -d "$PREFIX/lib" "$PREFIX/include" "$PREFIX/lib/cmake"
cp -a "$SRC_DIR/lib/." "$PREFIX/lib/"
cp -a "$SRC_DIR/include/." "$PREFIX/include/"
cp -a "$SRC_DIR/cmake/." "$PREFIX/lib/cmake/"

# Optional: install the solver binary if present
if [ -d "$SRC_DIR/bin" ]; then
  install -d "$PREFIX/bin"
  cp -a "$SRC_DIR/bin/." "$PREFIX/bin/"
fi

# Refresh dynamic linker cache when possible
if command -v ldconfig >/dev/null 2>&1; then
  ldconfig
fi

echo "cvc5 installation complete."

