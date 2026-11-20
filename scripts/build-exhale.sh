#!/usr/bin/env bash
# Static exhale.exe (xHE-AAC / USAC encoder).
source "$(dirname "$0")/lib.sh"
fetch_src
cmake_build "$SRC" "$WORK/build"
install_exe "$(find_exe exhale.exe "$WORK/build" "$SRC/bin")"
install_doc "$SRC/license.txt"
record_version "$OUT/exhale.exe"
