#!/usr/bin/env bash
# Copy selected install artifacts into ./lib, ./include, ./cmake
# Usage: ./collect_cvc5_artifacts.sh [/path/to/prefix]
# Defaults to /usr/local

set -euo pipefail

PREFIX="${1:-/usr/local}"
DEST="$(pwd)"

mkdir -p "$DEST/lib" "$DEST/include" "$DEST/cmake"

echo ">> Copying libraries to ./lib"
for f in \
  libcadical.a \
  libpicpoly.a \
  libpicpolyxx.a \
  libcvc5parser.a \
  libcvc5.a
do
  src="$PREFIX/lib/$f"
  [ -f "$src" ] || { echo "Missing: $src"; exit 1; }
  cp -p "$src" "$DEST/lib/"
done

echo ">> Copying headers to ./include"
incdir="$PREFIX/include/cvc5"
[ -d "$incdir" ] || { echo "Missing directory: $incdir"; exit 1; }
# Copies the whole cvc5 tree, including cvc5/, cvc5/c/, and headers
cp -pR "$incdir" "$DEST/include/"

echo ">> Copying CMake files to ./cmake"
cmakedir="$PREFIX/lib/cmake/cvc5"
[ -d "$cmakedir" ] || { echo "Missing directory: $cmakedir"; exit 1; }
# Preserves the cvc5 subdirectory structure under ./cmake
cp -pR "$cmakedir" "$DEST/cmake/"

echo "Done."

