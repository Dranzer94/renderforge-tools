#!/usr/bin/env bash
# Static uvg266.exe (VVC encoder).
source "$(dirname "$0")/lib.sh"
fetch_src
cmake_build "$SRC" "$WORK/build" -DBUILD_TESTS=OFF
install_exe "$(find_exe uvg266.exe "$WORK/build")"
install_doc "$SRC/LICENSE" LICENSE.txt
record_version "$OUT/uvg266.exe" --version
