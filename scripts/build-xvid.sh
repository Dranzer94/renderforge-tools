#!/usr/bin/env bash
# Static xvid_encraw.exe (Xvid MPEG-4 ASP encoder CLI) from the xvidcore tarball.
source "$(dirname "$0")/lib.sh"
fetch_src
export CFLAGS="-O2 -std=gnu17 -fpermissive"
cd "$SRC/build/generic"
./configure
# The generic Makefile also links xvidcore.dll; only the static library is needed.
make -k -j "$JOBS" || true
LIB="$(find "$SRC/build/generic" -name '*xvidcore*.a' ! -name '*.dll.a' -print -quit)"
[ -n "$LIB" ] || { echo "static xvidcore library not built" >&2; exit 1; }
gcc $CFLAGS -I"$SRC/src" "$SRC/examples/xvid_encraw.c" "$LIB" -lm $STATIC_LINK \
  -o "$WORK/xvid_encraw.exe"
install_exe "$WORK/xvid_encraw.exe"
install_doc "$SRC/LICENSE" LICENSE.txt
install_doc "$SRC/AUTHORS" AUTHORS.txt
record_version "$OUT/xvid_encraw.exe" -help
