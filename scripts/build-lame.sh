#!/usr/bin/env bash
# Static lame.exe (MP3 encoder) from the SourceForge release tarball.
source "$(dirname "$0")/lib.sh"
fetch_src
# LAME 4.0's Windows-only ID3 code in frontend/parse.c calls the deprecated *_ucs2
# helpers (still exported by libmp3lame) without a prototype and mixes char/UTF-16
# pointers. GCC 14+ makes those hard errors; -fpermissive turns them back into warnings.
export CFLAGS="-O2 -std=gnu17 -fpermissive -Wno-incompatible-pointer-types -Wno-implicit-function-declaration"
cd "$SRC"
# Keep the MSYS2 ncurses termcap out: its headers are DLL-import only, so a static
# link fails, and the Windows console code doesn't need it.
./configure ac_cv_header_termcap_h=no ac_cv_header_ncurses_termcap_h=no \
  ac_cv_lib_termcap_initscr=no ac_cv_lib_curses_initscr=no ac_cv_lib_ncurses_initscr=no \
  --disable-shared --enable-static --enable-nasm --disable-gtktest \
  --disable-dependency-tracking
make -j "$JOBS" LDFLAGS="$LT_STATIC_LDFLAGS"
install_exe "$(find_exe lame.exe "$SRC/frontend")"
install_doc "$SRC/COPYING" COPYING.txt
install_doc "$SRC/LICENSE" LICENSE.txt
record_version "$OUT/lame.exe" --version
