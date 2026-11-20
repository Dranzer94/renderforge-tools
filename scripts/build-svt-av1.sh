#!/usr/bin/env bash
# Build a static SvtAv1EncApp.exe in an MSYS2 UCRT64 shell.
# Usage: build-svt-av1.sh <git-url> <ref> <out-dir>
set -euo pipefail
GIT_URL="$1"; REF="$2"; OUT="$3"
WORK="$(pwd)/work-svt-av1"
rm -rf "$WORK" && mkdir -p "$WORK" "$OUT"
git clone --depth 1 --branch "$REF" "$GIT_URL" "$WORK/src"

cmake -S "$WORK/src" -B "$WORK/build" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBUILD_TESTING=OFF \
  -DBUILD_APPS=ON -DBUILD_DEC=OFF \
  -DCMAKE_EXE_LINKER_FLAGS="-static -static-libgcc -static-libstdc++"
cmake --build "$WORK/build"

EXE="$(find "$WORK/src/Bin" "$WORK/build" -name SvtAv1EncApp.exe -print -quit)"
[ -n "$EXE" ] || { echo "SvtAv1EncApp.exe not found" >&2; exit 1; }
cp "$EXE" "$OUT/"
cp "$WORK/src/LICENSE.md" "$OUT/LICENSE.md"
[ -f "$WORK/src/PATENTS.md" ] && cp "$WORK/src/PATENTS.md" "$OUT/PATENTS.md"
strip "$OUT/SvtAv1EncApp.exe"
"$OUT/SvtAv1EncApp.exe" --version 2>&1 | tee "$OUT/version.txt"
