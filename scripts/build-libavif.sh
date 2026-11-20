#!/usr/bin/env bash
# Static avifenc.exe and avifdec.exe (libavif with MSYS2 libaom + dav1d, libpng, libjpeg).
source "$(dirname "$0")/lib.sh"
fetch_src
cmake_build "$SRC" "$WORK/build" -DCMAKE_FIND_LIBRARY_SUFFIXES=.a \
  -DAVIF_BUILD_APPS=ON -DAVIF_BUILD_TESTS=OFF -DAVIF_BUILD_EXAMPLES=OFF \
  -DAVIF_CODEC_AOM=SYSTEM -DAVIF_CODEC_DAV1D=SYSTEM \
  -DAVIF_JPEG=SYSTEM -DAVIF_ZLIBPNG=SYSTEM -DAVIF_LIBYUV=OFF -DAVIF_LIBXML2=OFF \
  -DAVIF_LIBSHARPYUV=OFF
install_exe "$(find_exe avifenc.exe "$WORK/build")"
install_exe "$(find_exe avifdec.exe "$WORK/build")"
install_doc "$SRC/LICENSE" LICENSE.txt
record_version "$OUT/avifenc.exe" --version
