# Licence notes

This repo contains build scripts only. The scripts are under the MIT licence (see below). Every published binary keeps **its own upstream licence**, and each release zip includes the upstream licence file(s).

| Tool | Licence | What redistribution needs |
| --- | --- | --- |
| x265 | GPL-2.0-or-later (commercial licence also offered by MulticoreWare) | Ship `COPYING.txt` (included). The GPL requires the corresponding source to be offered: the release notes link the exact upstream tag, and `BUILDINFO.txt` records the commit. The build scripts here are the "scripts used to control compilation". Binaries are unmodified. HEVC is patent-encumbered in some countries. That is the end user's concern, but RenderForge should say so in the Encoder Manager. |
| SVT-AV1 | BSD-3-Clause-Clear, plus the AOMedia Patent License 1.0 | Ship `LICENSE.md` and `PATENTS.md` (included). |
| aomenc (planned) | BSD-2-Clause, plus the AOMedia Patent License 1.0 | Licence plus patent file. |
| dav1d (planned) | BSD-2-Clause | Licence file. |
| vpxenc (planned) | BSD-3-Clause, plus the WebM additional IP grant | Licence plus `PATENTS`. |
| vvenc (planned) | BSD-3-Clause-Clear | Licence file. VVC is patent-encumbered. |
| LAME (planned) | LGPL-2.0-or-later | Licence file. Offer the source (link to the tag). |
| fdk-aac | Fraunhofer FDK AAC licence (non-free for FFmpeg; no patent licence) | **Not built here.** RenderForge keeps fdk-aac opt-in, behind a licence warning. Revisit only after a separate decision. |

Static linking pulls in the MinGW-w64 runtime and libstdc++/libgcc. Their runtime exceptions (GCC Runtime Library Exception, and the MinGW-w64 public-domain or ZPL runtime) allow this without changing the tool's licence.

This is a practical summary, not legal advice.

## Build scripts licence (MIT)

Copyright (c) 2026 Dranzer94

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
