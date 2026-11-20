#!/usr/bin/env bash
# Static vvdecapp.exe (Fraunhofer VVC decoder).
source "$(dirname "$0")/lib.sh"
fetch_src
cmake_build "$SRC" "$WORK/build" -DVVDEC_LIBRARY_ONLY=OFF \
  -DVVDEC_ENABLE_LINK_TIME_OPT=OFF -DVVDEC_ENABLE_WERROR=OFF -DBUILD_TESTING=OFF
install_exe "$(find_exe vvdecapp.exe "$SRC/bin" "$WORK/build")"
install_doc "$SRC/LICENSE.txt"
record_version "$OUT/vvdecapp.exe" --version
