#!/usr/bin/env bash
# Static lame.exe (MP3 encoder) from the SourceForge release tarball.
source "$(dirname "$0")/lib.sh"
fetch_src
export CFLAGS="-O2 -std=gnu17"
cd "$SRC"
./configure --disable-shared --enable-static --enable-nasm --disable-gtktest \
  --disable-dependency-tracking
make -j "$JOBS"
install_exe "$(find_exe lame.exe "$SRC/frontend")"
install_doc "$SRC/COPYING" COPYING.txt
install_doc "$SRC/LICENSE" LICENSE.txt
record_version "$OUT/lame.exe" --version
