#!/usr/bin/env bash
# Static opusenc.exe, opusdec.exe and opusinfo.exe from an opus-tools master snapshot
# ($VERSION = git describe, e.g. 0.2-59-g4110587), linked against current MSYS2
# libopus / libogg / opusfile / libopusenc / FLAC. Upstream hasn't tagged since v0.2 (2018).
source "$(dirname "$0")/lib.sh"
commit="${VERSION##*-g}"
# Full clone (small repo): the build's version banner comes from git describe.
git clone -q --branch "$REF" "$SRC_URL" "$SRC"
git -C "$SRC" -c advice.detachedHead=false checkout -q "$commit"
git -C "$SRC" rev-parse HEAD > "$WORK/source-id.txt"
described="$(git -C "$SRC" describe --tags --long --abbrev=7 --match 'v[0-9]*')"
[ "${described#v}" = "$VERSION" ] || { echo "error: checked out $described, expected v$VERSION" >&2; exit 1; }
# FLAC__NO_DLL: link MSYS2 libFLAC statically (its headers default to dllimport).
export CFLAGS="-O2 -std=gnu17 -fpermissive -DFLAC__NO_DLL"
cd "$SRC"
./autogen.sh
./configure --disable-dependency-tracking
make -j "$JOBS" LDFLAGS="$LT_STATIC_LDFLAGS"
for exe in opusenc opusdec opusinfo; do
  install_exe "$(find_exe "$exe.exe" "$SRC")"
done
install_doc "$SRC/COPYING" COPYING.txt
# Library versions this snapshot was linked against (MSYS2 UCRT64 packages).
pacman -Q mingw-w64-ucrt-x86_64-opus mingw-w64-ucrt-x86_64-opusfile mingw-w64-ucrt-x86_64-libopusenc \
  mingw-w64-ucrt-x86_64-libogg mingw-w64-ucrt-x86_64-flac > "$OUT/LIBRARIES.txt" || true
cat "$OUT/LIBRARIES.txt"
record_version "$OUT/opusenc.exe" --version
