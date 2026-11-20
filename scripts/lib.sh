#!/usr/bin/env bash
# Shared helpers for scripts/build-<tool>.sh, run in an MSYS2 UCRT64 shell.
# Each build script is called as: build-<tool>.sh <src> <ref> <out-dir>
#   <src>  git URL, or a tarball URL (ending in .tar.gz/.tar.bz2/.tar.xz/.zip)
#   <ref>  upstream tag (git) or version (tarball)
#   <out>  directory that must end up holding the exe(s) plus licence file(s)
# The upstream version is also exported by the workflow as $VERSION.
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPTS_DIR")"
TOOL="$(basename "$0" .sh)"; TOOL="${TOOL#build-}"
SRC_URL="$1"; REF="$2"; OUT="$(mkdir -p "$3" && cd "$3" && pwd)"
WORK="$(pwd)/work-$TOOL"
SRC="$WORK/src"
JOBS="$(nproc)"
rm -rf "$WORK" && mkdir -p "$WORK"

# Fully static Windows executables (no libgcc/libstdc++/libwinpthread DLLs).
export CFLAGS="${CFLAGS:--O2 -pipe}"
export CXXFLAGS="${CXXFLAGS:--O2 -pipe}"
export LDFLAGS="${LDFLAGS:--static -static-libgcc -static-libstdc++}"
export PKG_CONFIG="pkg-config --static"
STATIC_LINK="-static -static-libgcc -static-libstdc++"
# libtool ignores plain -static for libraries it finds as .dll.a; -all-static forces .a.
LT_STATIC_LDFLAGS="-all-static $STATIC_LINK"
# CMake 4 refuses projects whose cmake_minimum_required is older than 3.5.
CMAKE_COMMON=(-G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
              -DCMAKE_POLICY_VERSION_MINIMUM=3.5
              "-DCMAKE_EXE_LINKER_FLAGS=$STATIC_LINK")

log() { echo "::group::$*"; }
endlog() { echo "::endgroup::"; }

# fetch_src: put the upstream source in $SRC (git tag clone or tarball).
fetch_src() {
  case "$SRC_URL" in
    *.tar.gz|*.tgz|*.tar.bz2|*.tar.xz|*.zip|*/download)
      mkdir -p "$WORK/dl" "$SRC"
      curl -fL --retry 5 --retry-delay 5 -A "renderforge-tools" -o "$WORK/dl/src.archive" "$SRC_URL"
      case "$SRC_URL" in
        *.zip) (cd "$WORK/dl" && unzip -q src.archive -d x) ;;
        *) mkdir -p "$WORK/dl/x" && tar -xf "$WORK/dl/src.archive" -C "$WORK/dl/x" ;;
      esac
      # Tarballs hold one top-level directory; flatten it into $SRC.
      local top; top="$(find "$WORK/dl/x" -mindepth 1 -maxdepth 1)"
      if [ "$(echo "$top" | wc -l)" = 1 ] && [ -d "$top" ]; then
        rmdir "$SRC" && mv "$top" "$SRC"
      else
        mv "$WORK/dl/x/"* "$SRC/"
      fi
      echo "tarball $SRC_URL" > "$WORK/source-id.txt"
      ;;
    *)
      git -c advice.detachedHead=false clone --depth 1 --branch "$REF" \
        --recurse-submodules --shallow-submodules "$SRC_URL" "$SRC"
      git -C "$SRC" rev-parse HEAD > "$WORK/source-id.txt"
      ;;
  esac
}

# cmake_build <source-dir> <build-dir> [extra cmake args...]
cmake_build() {
  local s="$1" b="$2"; shift 2
  cmake -S "$s" -B "$b" "${CMAKE_COMMON[@]}" "$@"
  cmake --build "$b" -j "$JOBS"
}

# find_exe <name> <dir...>: print the first match or fail.
find_exe() {
  local name="$1"; shift
  local f; f="$(find "$@" -type f -iname "$name" -print -quit 2>/dev/null || true)"
  [ -n "$f" ] || { echo "error: $name not found under $*" >&2; exit 1; }
  echo "$f"
}

# install_exe <path>: copy into $OUT and strip.
install_exe() {
  cp "$1" "$OUT/"
  strip "$OUT/$(basename "$1")"
}

# install_doc <path> [name]: copy a licence/notice file into $OUT (skip if missing).
install_doc() {
  [ -f "$1" ] || { echo "note: $1 missing, skipped"; return 0; }
  cp "$1" "$OUT/${2:-$(basename "$1")}"
}

# record_version <cmd...>: save the tool's own version banner to version.txt.
record_version() {
  { "$@" 2>&1 || true; } | head -n 20 | tee "$OUT/version.txt"
}
