#!/usr/bin/env bash
# Static dav1d.exe (AV1 decoder CLI).
source "$(dirname "$0")/lib.sh"
fetch_src
meson setup "$WORK/build" "$SRC" --buildtype=release --default-library=static \
  -Denable_tools=true -Denable_tests=false -Denable_examples=false \
  -Dc_link_args="$STATIC_LINK"
ninja -C "$WORK/build"
install_exe "$(find_exe dav1d.exe "$WORK/build/tools")"
install_doc "$SRC/COPYING" COPYING.txt
record_version "$OUT/dav1d.exe" --version
