#!/usr/bin/env bash
# Static SvtVp9EncApp.exe.
source "$(dirname "$0")/lib.sh"
fetch_src
export CFLAGS="-O2 -fpermissive -Wno-error -Wno-incompatible-pointer-types -Wno-int-conversion -Wno-implicit-function-declaration"
cmake_build "$SRC" "$WORK/build" "-DCMAKE_C_FLAGS=$CFLAGS"
install_exe "$(find_exe SvtVp9EncApp.exe "$SRC/Bin" "$WORK/build")"
install_doc "$SRC/LICENSE.md"
record_version "$OUT/SvtVp9EncApp.exe" -help
