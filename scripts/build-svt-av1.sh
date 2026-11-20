#!/usr/bin/env bash
# Static SvtAv1EncApp.exe.
source "$(dirname "$0")/lib.sh"
fetch_src
cmake_build "$SRC" "$WORK/build" -DBUILD_TESTING=OFF -DBUILD_APPS=ON -DBUILD_DEC=OFF
install_exe "$(find_exe SvtAv1EncApp.exe "$SRC/Bin" "$WORK/build")"
install_doc "$SRC/LICENSE.md"
install_doc "$SRC/PATENTS.md"
record_version "$OUT/SvtAv1EncApp.exe" --version
