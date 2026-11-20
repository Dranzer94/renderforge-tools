#!/usr/bin/env bash
# Static sox.exe (14.4.2, 2015). Minimal format set: WAV/AIFF/raw and the built-in
# effects (resampling, dither, gain); no external codec libraries.
source "$(dirname "$0")/lib.sh"
fetch_src
export CFLAGS="-O2 -std=gnu17 -fpermissive -Wno-incompatible-pointer-types -Wno-implicit-function-declaration -Wno-int-conversion"
cd "$SRC"
./configure --disable-shared --enable-static --disable-openmp --disable-dependency-tracking \
  --without-magic --without-png --without-ladspa --without-mad --without-id3tag \
  --without-lame --without-twolame --without-oggvorbis --without-opus --without-flac \
  --without-amrwb --without-amrnb --without-wavpack --without-sndfile --without-mp3 \
  --without-gsm --without-lpc10 --without-ao --without-pulseaudio --without-alsa \
  --without-oss --without-sndio --without-coreaudio --without-sunaudio --without-libltdl
make -j "$JOBS"
install_exe "$(find_exe sox.exe "$SRC/src")"
install_doc "$SRC/COPYING" COPYING.txt
install_doc "$SRC/LICENSE.GPL" LICENSE.GPL.txt
record_version "$OUT/sox.exe" --version
