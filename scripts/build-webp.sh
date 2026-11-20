#!/usr/bin/env bash
# Static cwebp.exe, dwebp.exe, img2webp.exe, webpinfo.exe, webpmux.exe (libwebp).
# PNG and JPEG input only (TIFF/GIF disabled to keep the static link simple).
source "$(dirname "$0")/lib.sh"
fetch_src
cmake_build "$SRC" "$WORK/build" -DCMAKE_FIND_LIBRARY_SUFFIXES=.a \
  -DWEBP_BUILD_CWEBP=ON -DWEBP_BUILD_DWEBP=ON -DWEBP_BUILD_IMG2WEBP=ON \
  -DWEBP_BUILD_WEBPINFO=ON -DWEBP_BUILD_WEBPMUX=ON -DWEBP_BUILD_GIF2WEBP=OFF \
  -DWEBP_BUILD_VWEBP=OFF -DWEBP_BUILD_EXTRAS=OFF -DWEBP_BUILD_ANIM_UTILS=OFF \
  -DCMAKE_DISABLE_FIND_PACKAGE_TIFF=ON -DCMAKE_DISABLE_FIND_PACKAGE_GIF=ON
for exe in cwebp dwebp img2webp webpinfo webpmux; do
  install_exe "$(find_exe "$exe.exe" "$WORK/build")"
done
install_doc "$SRC/COPYING" COPYING.txt
install_doc "$SRC/PATENTS" PATENTS.txt
record_version "$OUT/cwebp.exe" -version
