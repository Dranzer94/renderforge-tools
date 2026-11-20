#!/usr/bin/env bash
# Static fdkaac.exe (nu774/fdkaac front end) linked against libfdk-aac (mstorsjo/fdk-aac,
# newest stable tag). OPT-IN ONLY: libfdk-aac is under the Fraunhofer FDK AAC licence,
# which grants no patent licence; see LICENSES.md.
source "$(dirname "$0")/lib.sh"
fetch_src
FDK_GIT=https://github.com/mstorsjo/fdk-aac.git
FDK_TAG="$(git ls-remote --tags --refs "$FDK_GIT" | sed 's#.*refs/tags/##' \
  | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -1)"
echo "libfdk-aac tag: $FDK_TAG"
git -c advice.detachedHead=false clone --depth 1 --branch "$FDK_TAG" "$FDK_GIT" "$WORK/fdk-aac"
cmake -S "$WORK/fdk-aac" -B "$WORK/fdk-build" "${CMAKE_COMMON[@]}" \
  -DBUILD_PROGRAMS=OFF -DCMAKE_INSTALL_PREFIX="$WORK/prefix"
cmake --build "$WORK/fdk-build" -j "$JOBS" --target install
export PKG_CONFIG_PATH="$WORK/prefix/lib/pkgconfig"
cd "$SRC"
autoreconf -fi
./configure --disable-dependency-tracking
make -j "$JOBS"
install_exe "$(find_exe fdkaac.exe "$SRC")"
install_doc "$SRC/COPYING" COPYING-fdkaac.txt
install_doc "$WORK/fdk-aac/NOTICE" NOTICE-libfdk-aac.txt
echo "libfdk-aac $FDK_TAG ($(git -C "$WORK/fdk-aac" rev-parse HEAD))" >> "$WORK/source-id.txt"
cp "$REPO_DIR/docs/fdkaac-README.txt" "$OUT/README-LICENCE.txt"
record_version "$OUT/fdkaac.exe" --help
