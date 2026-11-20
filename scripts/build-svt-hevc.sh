#!/usr/bin/env bash
# Static SvtHevcEncApp.exe. Upstream is archived (last tag v1.5.1, 2021), so newer
# GCC needs its stricter C diagnostics relaxed.
source "$(dirname "$0")/lib.sh"
fetch_src
export CFLAGS="-O2 -fpermissive -Wno-error -Wno-incompatible-pointer-types -Wno-int-conversion -Wno-implicit-function-declaration"
cmake_build "$SRC" "$WORK/build" "-DCMAKE_C_FLAGS=$CFLAGS"
install_exe "$(find_exe SvtHevcEncApp.exe "$SRC/Bin" "$WORK/build")"
install_doc "$SRC/LICENSE.md"
record_version "$OUT/SvtHevcEncApp.exe" -help
