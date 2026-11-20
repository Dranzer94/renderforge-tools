#!/usr/bin/env bash
# Static multilib (8/10/12-bit) x265.exe.
source "$(dirname "$0")/lib.sh"
# Full single-branch clone of the tag: x265's CMake reads its version with git describe.
git -c advice.detachedHead=false clone --branch "$REF" --single-branch "$SRC_URL" "$SRC"
git -C "$SRC" rev-parse HEAD > "$WORK/source-id.txt"

COMMON=(-G Ninja -DCMAKE_BUILD_TYPE=Release -DENABLE_SHARED=OFF
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DENABLE_ASSEMBLY=ON)

cmake -S "$SRC/source" -B "$WORK/12bit" "${COMMON[@]}" \
  -DHIGH_BIT_DEPTH=ON -DMAIN12=ON -DEXPORT_C_API=OFF -DENABLE_CLI=OFF
cmake --build "$WORK/12bit" -j "$JOBS"

cmake -S "$SRC/source" -B "$WORK/10bit" "${COMMON[@]}" \
  -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF -DENABLE_CLI=OFF
cmake --build "$WORK/10bit" -j "$JOBS"

mkdir -p "$WORK/8bit"
cp "$WORK/12bit/libx265.a" "$WORK/8bit/libx265_main12.a"
cp "$WORK/10bit/libx265.a" "$WORK/8bit/libx265_main10.a"
# x265's CMake wraps EXTRA_LIB in "-Wl,-Bstatic ... -Wl,-Bdynamic", which made the
# 20 Nov run link libstdc++/libgcc_s/libwinpthread dynamically even with -static.
# Ending the standard library list with -Wl,-Bstatic switches the linker back to
# static mode for the runtime libraries GCC appends after it.
cmake -S "$SRC/source" -B "$WORK/8bit" "${COMMON[@]}" \
  -DEXTRA_LIB="x265_main10.a;x265_main12.a" \
  -DEXTRA_LINK_FLAGS="-L$WORK/8bit" \
  -DLINKED_10BIT=ON -DLINKED_12BIT=ON -DSTATIC_LINK_CRT=ON \
  "-DCMAKE_EXE_LINKER_FLAGS=$STATIC_LINK" \
  "-DCMAKE_CXX_STANDARD_LIBRARIES=-lkernel32 -luser32 -lgdi32 -lwinspool -lshell32 -lole32 -loleaut32 -luuid -lcomdlg32 -ladvapi32 -Wl,-Bstatic"
cmake --build "$WORK/8bit" -j "$JOBS" -v

install_exe "$WORK/8bit/x265.exe"
install_doc "$SRC/COPYING" COPYING.txt
record_version "$OUT/x265.exe" --version
