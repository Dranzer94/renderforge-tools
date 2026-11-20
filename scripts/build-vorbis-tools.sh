#!/usr/bin/env bash
# Static oggenc.exe, oggdec.exe, ogginfo.exe and vorbiscomment.exe (needs libogg, libvorbis).
source "$(dirname "$0")/lib.sh"
fetch_src
export CFLAGS="-O2 -std=gnu17"
cd "$SRC"
./configure --disable-shared --disable-nls --disable-ogg123 --disable-vcut \
  --without-flac --without-speex --without-kate --without-curl \
  --disable-dependency-tracking
make -j "$JOBS"
for exe in oggenc oggdec ogginfo vorbiscomment; do
  install_exe "$(find_exe "$exe.exe" "$SRC/$exe")"
done
install_doc "$SRC/COPYING" COPYING.txt
record_version "$OUT/oggenc.exe" --version
