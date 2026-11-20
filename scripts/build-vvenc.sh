#!/usr/bin/env bash
# Static vvencapp.exe and vvencFFapp.exe (Fraunhofer VVC encoder).
source "$(dirname "$0")/lib.sh"
fetch_src
cmake_build "$SRC" "$WORK/build" -DVVENC_LIBRARY_ONLY=OFF \
  -DVVENC_ENABLE_LINK_TIME_OPT=OFF -DVVENC_ENABLE_WERROR=OFF -DBUILD_TESTING=OFF
install_exe "$(find_exe vvencapp.exe "$SRC/bin" "$WORK/build")"
install_exe "$(find_exe vvencFFapp.exe "$SRC/bin" "$WORK/build")"
install_doc "$SRC/LICENSE.txt"
record_version "$OUT/vvencapp.exe" --version
