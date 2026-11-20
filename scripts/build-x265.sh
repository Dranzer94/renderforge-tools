#!/usr/bin/env bash
# Build a static multilib (8/10/12-bit) x265.exe in an MSYS2 UCRT64 shell.
# Usage: build-x265.sh <git-url> <ref> <out-dir>
set -euo pipefail
GIT_URL="$1"; REF="$2"; OUT="$3"
WORK="$(pwd)/work-x265"
rm -rf "$WORK" && mkdir -p "$WORK" "$OUT"
# Full clone of one tag (x265's CMake reads the version with git describe).
git clone --branch "$REF" --single-branch "$GIT_URL" "$WORK/src"

# x265 still declares an old cmake_minimum_required; CMake 4 needs this policy floor.
COMMON=(-G Ninja -DCMAKE_BUILD_TYPE=Release -DENABLE_SHARED=OFF
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DENABLE_ASSEMBLY=ON)

cmake -S "$WORK/src/source" -B "$WORK/12bit" "${COMMON[@]}" \
  -DHIGH_BIT_DEPTH=ON -DMAIN12=ON -DEXPORT_C_API=OFF -DENABLE_CLI=OFF
cmake --build "$WORK/12bit"

cmake -S "$WORK/src/source" -B "$WORK/10bit" "${COMMON[@]}" \
  -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_CLI=OFF
cmake --build "$WORK/10bit"

mkdir -p "$WORK/8bit"
cp "$WORK/12bit/libx265.a" "$WORK/8bit/libx265_main12.a"
cp "$WORK/10bit/libx265.a" "$WORK/8bit/libx265_main10.a"
cmake -S "$WORK/src/source" -B "$WORK/8bit" "${COMMON[@]}" \
  -DEXTRA_LIB="x265_main10.a;x265_main12.a" -DEXTRA_LINK_FLAGS="-L$WORK/8bit" \
  -DLINKED_10BIT=ON -DLINKED_12BIT=ON \
  -DCMAKE_EXE_LINKER_FLAGS="-static -static-libgcc -static-libstdc++"
cmake --build "$WORK/8bit"

cp "$WORK/8bit/x265.exe" "$OUT/"
cp "$WORK/src/COPYING" "$OUT/COPYING.txt"
strip "$OUT/x265.exe"
"$OUT/x265.exe" --version 2>&1 | tee "$OUT/version.txt"
