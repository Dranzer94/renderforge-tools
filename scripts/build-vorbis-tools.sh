#!/usr/bin/env bash
# Static oggenc.exe, oggdec.exe, ogginfo.exe and vorbiscomment.exe (needs libogg, libvorbis).
source "$(dirname "$0")/lib.sh"
fetch_src
export CFLAGS="-O2 -std=gnu17"
cd "$SRC"
# Build fix (not a behaviour change): share/utf8.c only defines convert_free_charset()
# outside its _WIN32 branch, but oggenc/ogginfo/vorbiscomment call it on Windows too.
sed -i 's|^#else /\* End win32.*|void convert_free_charset(void) {}\n&|' share/utf8.c
grep -n "convert_free_charset" share/utf8.c
./configure --disable-shared --disable-nls --disable-ogg123 --disable-vcut \
  --without-flac --without-speex --without-kate --without-curl \
  --disable-dependency-tracking
make -j "$JOBS" LDFLAGS="$LT_STATIC_LDFLAGS"
for exe in oggenc oggdec ogginfo vorbiscomment; do
  install_exe "$(find_exe "$exe.exe" "$SRC/$exe")"
done
install_doc "$SRC/COPYING" COPYING.txt
record_version "$OUT/oggenc.exe" --version
