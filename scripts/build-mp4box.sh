#!/usr/bin/env bash
# Static MP4Box.exe from a GPAC release tag (LGPL-2.1-or-later).
# Minimal build: zlib only, every optional library off (GPL ones such as xvid, faad, mad, a52
# and FFmpeg included), so the result stays LGPL and needs no DLLs. MP4Box's muxing, import,
# export, DASH/HLS packaging and ISOBMFF tools work; decoders/encoders/players are not built.
source "$(dirname "$0")/lib.sh"
fetch_src
cd "$SRC"
no_libs="opensvc openhevc platinum freetype ssl jpeg openjpeg png mad a52 xvid faad ffmpeg freenect
         vorbis theora nghttp2 ngtcp2 nghttp3 oss dvb4linux alsa pulseaudio jack directfb hid lzma
         tinygl vtb ogg sdl caption mpeghdec libcaca curl"
opts=()
for lib in $no_libs; do opts+=("--use-$lib=no"); done
# GPAC_ALLOW_UNSAFE_STRFUNC: GPAC #defines strncpy & co. to #error, which breaks the inline
# functions of mingw-w64's io.h; GPAC's own code doesn't use them either way.
./configure --static-bin --use-zlib=system "${opts[@]}" \
  --extra-cflags="-DGPAC_ALLOW_UNSAFE_STRFUNC" --extra-ldflags="$STATIC_LINK"
make -j "$JOBS"
install_exe "$(find_exe MP4Box.exe "$SRC/bin")"
install_doc "$SRC/COPYING" COPYING.txt
cat > "$OUT/README-LICENCE.txt" <<TXT
MP4Box is part of GPAC (https://gpac.io), licensed under the GNU Lesser General Public
License v2.1 or later (COPYING.txt). This build is unmodified upstream GPAC ${VERSION} (tag ${REF},
commit $(git rev-parse HEAD)), statically linked with zlib (zlib licence) and the
MinGW-w64 runtime. The complete corresponding source is attached to the same GitHub release as
mp4box-${VERSION}-source.tar.gz and is also available from https://github.com/gpac/gpac/tree/${REF}.
Build recipe: https://github.com/Dranzer94/renderforge-tools/blob/main/scripts/build-mp4box.sh
TXT
# Exact source for the release (LGPL: offered from the same place as the binary).
git archive --format=tar.gz --prefix="gpac-${VERSION}/" -o "$WORK/source.tar.gz" HEAD
record_version "$OUT/MP4Box.exe" -version
