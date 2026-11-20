#!/usr/bin/env bash
# Static vpxenc.exe and vpxdec.exe (libvpx, VP8 + VP9 with high bit depth).
source "$(dirname "$0")/lib.sh"
fetch_src
mkdir -p "$WORK/build" && cd "$WORK/build"
"$SRC/configure" --target=x86_64-win64-gcc --as=nasm \
  --disable-shared --enable-static --disable-unit-tests --disable-docs \
  --disable-tools --enable-vp9-highbitdepth --enable-postproc --enable-vp9-postproc \
  --enable-runtime-cpu-detect --extra-cflags="-O2" --extra-cxxflags="-O2"
make -j "$JOBS" LDFLAGS="$STATIC_LINK"
install_exe "$(find_exe vpxenc.exe "$WORK/build")"
install_exe "$(find_exe vpxdec.exe "$WORK/build")"
install_doc "$SRC/LICENSE"
install_doc "$SRC/PATENTS"
install_doc "$SRC/AUTHORS"
VERSION_GREP="WebM Project VP[89]" record_version "$OUT/vpxenc.exe" --help
