#!/usr/bin/env bash
# Static opusenc.exe, opusdec.exe and opusinfo.exe from the xiph release tarball,
# linked against current MSYS2 libopus/libogg/opusfile/libopusenc/FLAC.
source "$(dirname "$0")/lib.sh"
fetch_src
export CFLAGS="-O2 -std=gnu17 -fpermissive"
cd "$SRC"
./configure --disable-dependency-tracking
make -j "$JOBS" LDFLAGS="$LT_STATIC_LDFLAGS"
for exe in opusenc opusdec opusinfo; do
  install_exe "$(find_exe "$exe.exe" "$SRC")"
done
install_doc "$SRC/COPYING" COPYING.txt
record_version "$OUT/opusenc.exe" --version
