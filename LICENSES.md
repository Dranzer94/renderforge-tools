# Licence notes

This repo contains build scripts only. The scripts are under the MIT licence (see below). Every published binary keeps **its own upstream licence**, and each release zip includes the upstream licence file(s).

| Tool | Licence | What redistribution needs |
| --- | --- | --- |
| x265 | GPL-2.0-or-later (commercial licence also offered by MulticoreWare) | Ship `COPYING.txt` (included). The GPL requires the corresponding source to be offered: the release notes link the exact upstream tag, and `BUILDINFO.txt` records the commit. The build scripts here are the "scripts used to control compilation". Binaries are unmodified. HEVC is patent-encumbered in some countries. That is the end user's concern, but RenderForge should say so in the Encoder Manager. |
| SVT-AV1 | BSD-3-Clause-Clear, plus the AOMedia Patent License 1.0 | Ship `LICENSE.md` and `PATENTS.md` (included). |
| aom (aomenc, aomdec) | BSD-2-Clause, plus the AOMedia Patent License 1.0 | Ship `LICENSE` and `PATENTS` (included). |
| dav1d | BSD-2-Clause | Ship `COPYING.txt` (included). |
| vpx (vpxenc, vpxdec) | BSD-3-Clause, plus the WebM additional IP rights grant | Ship `LICENSE`, `PATENTS`, `AUTHORS` (included). |
| uvg266 | BSD-3-Clause | Ship `LICENSE.txt` (included). VVC is patent-encumbered. |
| vvenc, vvdec | BSD-3-Clause-Clear | Ship `LICENSE.txt` (included). VVC is patent-encumbered; the licence grants no patent rights. |
| SVT-HEVC, SVT-VP9 | BSD-2-Clause-Patent | Ship `LICENSE.md` (included). |
| Xvid (xvid_encraw) | GPL-2.0-or-later | Ship `LICENSE.txt` (included); source offered via the linked upstream tarball. MPEG-4 ASP patents have largely expired. |
| LAME | LGPL-2.0-or-later (statically linked into its own exe, which is fine for a stand-alone program) | Ship `COPYING.txt`/`LICENSE.txt` (included); source offered via the linked upstream tarball. Also links libmpg123 (LGPL-2.1) for decoding. MP3 patents have expired. |
| exhale | exhale Copyright License (modified BSD-3-Clause; no patent licence) | Ship `License.htm` (included from the next build). xHE-AAC/USAC needs patent licences (Via LA) for use; that is the user's concern. |
| Speex (speexenc, speexdec) | BSD-3-Clause; links libogg (BSD-3-Clause) | Ship `COPYING.txt` (included). |
| vorbis-tools (oggenc, ...) | GPL-2.0-or-later; links libogg/libvorbis (BSD-3-Clause) | Ship `COPYING.txt` (included); source offered via the linked tarball. One-line Windows build fix to `share/utf8.c`, done in `scripts/build-vorbis-tools.sh`. |
| SoX | GPL-2.0-or-later (sox.exe), LGPL for libsox | Ship `COPYING.txt` and `LICENSE.GPL.txt` (included). Windows build fix to `src/formats.c` (disables pipe rewinding), done in `scripts/build-sox.sh`. |
| **fdkaac (opt-in)** | Front end: Zlib. Library: Fraunhofer FDK AAC licence (redistribution allowed with the licence text and free source; **no patent licence**; not GPL-compatible) | Published as a separate, clearly labelled opt-in release with `NOTICE-libfdk-aac.txt`, `COPYING-fdkaac.txt` and `README-LICENCE.txt`. `BUILDINFO.txt` records both upstream commits; libfdk-aac is unmodified. RenderForge must never install it by default and must show its licence warning first. |

Static linking pulls in the MinGW-w64 runtime and libstdc++/libgcc. Their runtime exceptions (GCC Runtime Library Exception, and the MinGW-w64 public-domain or ZPL runtime) allow this without changing the tool's licence.

This is a practical summary, not legal advice.

## Build scripts licence (MIT)

Copyright (c) 2026 Dranzer94

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
