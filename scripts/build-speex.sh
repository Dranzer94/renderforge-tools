#!/usr/bin/env bash
# Static speexenc.exe and speexdec.exe from the xiph release tarball (needs libogg).
source "$(dirname "$0")/lib.sh"
fetch_src
cd "$SRC"
./configure --disable-shared --enable-static --enable-binaries --disable-dependency-tracking
make -j "$JOBS" LDFLAGS="$LT_STATIC_LDFLAGS"
install_exe "$(find_exe speexenc.exe "$SRC/src")"
install_exe "$(find_exe speexdec.exe "$SRC/src")"
install_doc "$SRC/COPYING" COPYING.txt
record_version "$OUT/speexenc.exe" --version
