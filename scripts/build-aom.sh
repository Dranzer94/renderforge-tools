#!/usr/bin/env bash
# Static aomenc.exe and aomdec.exe (libaom, high bit depth enabled).
source "$(dirname "$0")/lib.sh"
fetch_src
cmake_build "$SRC" "$WORK/build" \
  -DENABLE_TESTS=0 -DENABLE_DOCS=0 -DENABLE_EXAMPLES=1 -DENABLE_TOOLS=0 \
  -DENABLE_TESTDATA=0 -DCONFIG_AV1_HIGHBITDEPTH=1 -DENABLE_NASM=1
install_exe "$(find_exe aomenc.exe "$WORK/build")"
install_exe "$(find_exe aomdec.exe "$WORK/build")"
install_doc "$SRC/LICENSE"
install_doc "$SRC/PATENTS"
record_version "$OUT/aomenc.exe" --help
