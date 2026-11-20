# renderforge-tools

Windows x64 builds of video and audio encoders that **have no official Windows binaries**, built unmodified from upstream release tags and published as GitHub Releases. The [RenderForge](https://github.com/Dranzer94/RenderForge) Encoder Manager downloads them after install, so the RenderForge installer never bundles third-party encoders.

Tools with good official Windows builds (FFmpeg via BtbN, x264 via VideoLAN, MKVToolNix, MediaInfo, FLAC, rav1e and so on) are **not** built here; the Encoder Manager downloads those from their own publishers.

## What is built

Status is updated after each workflow change; the Releases page is the source of truth.

| Tool id (tag prefix) | Upstream (version source) | Exe(s) in the zip | Status |
| --- | --- | --- | --- |
| `x265` | [multicoreware/x265_git](https://bitbucket.org/multicoreware/x265_git) numeric tags (`4.2`) | `x265.exe` (8/10/12-bit multilib) | built: [`x265-4.2`](https://github.com/Dranzer94/renderforge-tools/releases/tag/x265-4.2) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44821672876)) |
| `svt-av1` | [AOMediaCodec/SVT-AV1](https://github.com/AOMediaCodec/SVT-AV1) `vX.Y.Z` tags | `SvtAv1EncApp.exe` | built: [`svt-av1-4.3.1`](https://github.com/Dranzer94/renderforge-tools/releases/tag/svt-av1-4.3.1) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44801125322)) |
| `aom` | [aomedia.googlesource.com/aom](https://aomedia.googlesource.com/aom) `vX.Y.Z` tags | `aomenc.exe`, `aomdec.exe` | built: [`aom-3.15.3`](https://github.com/Dranzer94/renderforge-tools/releases/tag/aom-3.15.3) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44821672876)) |
| `dav1d` | [code.videolan.org/videolan/dav1d](https://code.videolan.org/videolan/dav1d) `X.Y.Z` tags | `dav1d.exe` | built: [`dav1d-1.5.5`](https://github.com/Dranzer94/renderforge-tools/releases/tag/dav1d-1.5.5) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44821672876)) |
| `vpx` | [chromium.googlesource.com/webm/libvpx](https://chromium.googlesource.com/webm/libvpx) `vX.Y.Z` tags | `vpxenc.exe`, `vpxdec.exe` (VP9 high bit depth) | built: [`vpx-1.17.0`](https://github.com/Dranzer94/renderforge-tools/releases/tag/vpx-1.17.0) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44821672876)) |
| `uvg266` | [ultravideo/uvg266](https://github.com/ultravideo/uvg266) `vX.Y.Z` tags | `uvg266.exe` | built: [`uvg266-0.8.1`](https://github.com/Dranzer94/renderforge-tools/releases/tag/uvg266-0.8.1) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44821672876)) |
| `vvenc` | [fraunhoferhhi/vvenc](https://github.com/fraunhoferhhi/vvenc) `vX.Y.Z` tags | `vvencapp.exe`, `vvencFFapp.exe` | built: [`vvenc-1.14.0`](https://github.com/Dranzer94/renderforge-tools/releases/tag/vvenc-1.14.0) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44821672876)) |
| `vvdec` | [fraunhoferhhi/vvdec](https://github.com/fraunhoferhhi/vvdec) `vX.Y.Z` tags | `vvdecapp.exe` | built: [`vvdec-3.3.0`](https://github.com/Dranzer94/renderforge-tools/releases/tag/vvdec-3.3.0) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44821672876)) |
| `svt-hevc` | [OpenVisualCloud/SVT-HEVC](https://github.com/OpenVisualCloud/SVT-HEVC) `vX.Y.Z` tags (archived upstream) | `SvtHevcEncApp.exe` | built: [`svt-hevc-1.5.1`](https://github.com/Dranzer94/renderforge-tools/releases/tag/svt-hevc-1.5.1) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44821672876)) |
| `svt-vp9` | [OpenVisualCloud/SVT-VP9](https://github.com/OpenVisualCloud/SVT-VP9) `vX.Y.Z` tags | `SvtVp9EncApp.exe` | built: [`svt-vp9-0.3.1`](https://github.com/Dranzer94/renderforge-tools/releases/tag/svt-vp9-0.3.1) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44821672876)) |
| `xvid` | [downloads.xvid.com](https://downloads.xvid.com/downloads/) `xvidcore-X.Y.Z.tar.gz` | `xvid_encraw.exe` | built: [`xvid-1.3.7`](https://github.com/Dranzer94/renderforge-tools/releases/tag/xvid-1.3.7) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44827293538)) |
| `lame` | [SourceForge lame](https://sourceforge.net/projects/lame/files/lame/) release tarballs | `lame.exe` | built: [`lame-4.0`](https://github.com/Dranzer94/renderforge-tools/releases/tag/lame-4.0) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44827293538)) |
| `exhale` | [gitlab.com/ecodis/exhale](https://gitlab.com/ecodis/exhale) `vX.Y.Z` tags | `exhale.exe` | built: [`exhale-1.2.2`](https://github.com/Dranzer94/renderforge-tools/releases/tag/exhale-1.2.2) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44822964808)) |
| `speex` | [xiph/speex](https://gitlab.xiph.org/xiph/speex) `Speex-X.Y.Z` tags, xiph release tarball | `speexenc.exe`, `speexdec.exe` | built: [`speex-1.2.1`](https://github.com/Dranzer94/renderforge-tools/releases/tag/speex-1.2.1) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44822964808)) |
| `vorbis-tools` | [xiph/vorbis-tools](https://gitlab.xiph.org/xiph/vorbis-tools) `vX.Y.Z` tags, xiph release tarball | `oggenc.exe`, `oggdec.exe`, `ogginfo.exe`, `vorbiscomment.exe` | built: [`vorbis-tools-1.4.3`](https://github.com/Dranzer94/renderforge-tools/releases/tag/vorbis-tools-1.4.3) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44822964808)) |
| `sox` | [SourceForge sox](https://sourceforge.net/projects/sox/files/sox/) release tarballs | `sox.exe` (WAV/AIFF/raw plus built-in effects only) | built: [`sox-14.4.2`](https://github.com/Dranzer94/renderforge-tools/releases/tag/sox-14.4.2) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44822964808)) |
| `opus-tools` | [xiph/opus-tools](https://gitlab.xiph.org/xiph/opus-tools) `vX.Y` tags, xiph release tarball, current MSYS2 libopus | `opusenc.exe`, `opusdec.exe`, `opusinfo.exe` | built: [`opus-tools-0.2`](https://github.com/Dranzer94/renderforge-tools/releases/tag/opus-tools-0.2) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44829360213)), libopus 1.6.1 |
| `webp` | [chromium.googlesource.com/webm/libwebp](https://chromium.googlesource.com/webm/libwebp) `vX.Y.Z` tags | `cwebp.exe`, `dwebp.exe`, `img2webp.exe`, `webpinfo.exe`, `webpmux.exe` (PNG/JPEG input) | built: [`webp-1.6.0`](https://github.com/Dranzer94/renderforge-tools/releases/tag/webp-1.6.0) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44828056705)) |
| `fdkaac` (**opt-in**) | [nu774/fdkaac](https://github.com/nu774/fdkaac) `vX.Y.Z` tags + newest [mstorsjo/fdk-aac](https://github.com/mstorsjo/fdk-aac) tag | `fdkaac.exe` | built: [`fdkaac-1.0.9`](https://github.com/Dranzer94/renderforge-tools/releases/tag/fdkaac-1.0.9) ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44821672876)) |

### Not built here, because a reliable official Windows build exists

opus-tools and WebP also have official Windows builds (Mozilla's `opus-tools-0.2-win64.zip`, Google's `libwebp-<v>-windows-x64.zip`); they are built here as well so RenderForge gets newer libraries and the same release pattern, and the official builds stay listed as alternatives in the catalogue.

| Tool | Use instead |
| --- | --- |
| avifenc (libavif) | Official `windows-artifacts.zip` on [AOMediaCodec/libavif releases](https://github.com/AOMediaCodec/libavif/releases). |
| mpv | Official `mpv-v<v>-x86_64-pc-windows-msvc.zip` on [mpv-player/mpv releases](https://github.com/mpv-player/mpv/releases) (since 0.41). |
| Av1an | Official rolling `av1an.exe` on the [rust-av/Av1an `latest` release](https://github.com/rust-av/Av1an/releases/tag/latest). Tagged releases have no binaries. Needs VapourSynth or FFMS2 at run time. |
| cyanrip | Official `cyanrip-win64.exe` on [cyanreg/cyanrip releases](https://github.com/cyanreg/cyanrip/releases). |
| faac | Official `faac-<v>-MSYS2-UCRT64.zip` on [knik0/faac releases](https://github.com/knik0/faac/releases). |
| Tesseract | Skipped: large (language data), and UB-Mannheim publishes the de-facto Windows installer. Not an encoder. |

### fdkaac decision

fdkaac is built, but **only as a clearly labelled opt-in release**. The front end is Zlib-licensed; libfdk-aac is under the Fraunhofer FDK AAC licence, which **does allow binary redistribution** (keep the licence text, make the unmodified source available free of charge) but **grants no patent licence** and is not GPL-compatible. So:

- the release title says "OPT-IN, restricted licence" and the notes explain the licence;
- the zip carries `NOTICE-libfdk-aac.txt`, `COPYING-fdkaac.txt` and `README-LICENCE.txt`; `BUILDINFO.txt` records both upstream commits;
- `tool=standard` builds everything except it; RenderForge must keep it out of the default install and behind its licence warning.

If Lewis prefers not to host it at all, delete the `fdkaac-*` releases and remove the entry from `scripts/plan.py`; nothing else depends on it.

## Release layout (the contract RenderForge relies on)

One pattern for every tool, so a single RenderForge resolver handles them all:

| Item | Pattern | Example |
| --- | --- | --- |
| Release tag | `<tool>-<version>` | `vvenc-1.14.0` |
| Zip asset | `<tool>-<version>-win64.zip`, regex `^<tool>-[0-9.]+-win64\.zip$` | `vvenc-1.14.0-win64.zip` |
| Checksums | `SHA256SUMS` (`sha256sum` format: `<hex>  <zip name>`). An identical `checksums.sha256` is also attached for older resolvers. GitHub's asset `digest` field carries the same SHA-256. | |

- `<tool>` is the id in the first table (the same as the RenderForge catalogue id). `<version>` is the upstream version without any `v` prefix.
- The zip holds the exe(s) at its root, the upstream licence file(s), `version.txt` (first line `<tool> <version>`, then the exe's own version or help banner) and `BUILDINFO.txt` (upstream ref and commit or tarball URL, compiler, build-log link).
- Release notes link the upstream changelog, source and build log, and repeat the SHA-256.
- Opt-in tools (currently only `fdkaac`) use the same pattern; their release title ends in "OPT-IN, restricted licence" and the notes open with the licence warning.
- Releases are created with `--latest=false`, so don't use `/releases/latest`. List releases (`GET /repos/Dranzer94/renderforge-tools/releases`), keep tags starting with `<tool>-`, and pick the highest version.

## How builds run

`.github/workflows/build.yml`:

1. **plan** (Ubuntu): `scripts/plan.py` finds each tool's newest upstream version (`git ls-remote` tags, or a regex over the download page/RSS for tarball-only projects: Xvid, LAME, SoX) and keeps only tools whose `<tool>-<version>` release doesn't exist yet (all of them with `force`). A failed upstream lookup only skips that tool.
2. **build** (windows-latest, one independent job per tool, `fail-fast: false`): MSYS2 UCRT64 with GCC, CMake, Ninja, NASM, pkgconf plus the tool's extra packages, then `scripts/build-<tool>.sh`. Shared helpers live in `scripts/lib.sh` (fetch, static link flags, CMake defaults, install and version helpers). The job then checks no exe needs MSYS2 DLLs, zips, writes `SHA256SUMS` and publishes the release.

Triggers:

- **Weekly schedule** (Mondays 04:17 UTC): builds only new upstream versions; tools that are up to date cost nothing beyond the plan job.
- **Manual**: Actions → Build tools → Run workflow, or for example
  `gh workflow run build.yml -f tool=x265 -f version=4.1 -f force=true`
  `tool` takes one id, a comma list (`lame,xvid`), `standard` (all except opt-in) or `all`.

Builds use upstream source unmodified, except for these small Windows build fixes applied by the scripts: vorbis-tools (`share/utf8.c` stub for `convert_free_charset`), SoX (`src/formats.c` pipe-rewind hack disabled), x265 (link-line flag only), SVT-HEVC/SVT-VP9 (relaxed GCC diagnostics only).

## Adding a tool

1. Add an entry to `TOOLS` in `scripts/plan.py` (version source, `src`, `ref`, extra `pkgs`, changelog and source URLs).
2. Add `scripts/build-<tool>.sh <src> <ref> <out-dir>`: `source lib.sh`, then build and leave static exe(s) plus licence file(s) in `$OUT` (see the existing scripts).
3. Add or update its licence notes in [LICENSES.md](LICENSES.md).
4. Point the tool's RenderForge catalogue entry (`data/encoders.json`, source type `curated`) at this repo with `tag_prefix: "<tool>-"` and the asset regex above.

## Blocked or skipped tools

| Tool | Why it isn't built |
| --- | --- |
| libavif (avifenc) | First attempt ([run](https://github.com/Dranzer94/renderforge-tools/actions/runs/44828056705)) built, but CMake picked MSYS2's DLL import libraries for libaom, dav1d, libpng, libjpeg and zlib, so the exe failed the no-DLL check. A static build needs libavif's `LOCAL` codec/image-library options (building aom, dav1d, libpng and libjpeg from source inside the job). Not worth it while the official `windows-artifacts.zip` (static `avifenc.exe`/`avifdec.exe`) exists, so it's removed from the schedule; `scripts/build-libavif.sh` stays as a starting point. |
| Tesseract | Skipped on purpose: large, needs language data, not an encoder; UB-Mannheim's installer is the de-facto Windows build. |
| mpv, Av1an, cyanrip, faac | Not needed: official Windows builds exist (table above). |

Known limits: opus-tools upstream hasn't tagged since 0.2 (2018), so the weekly schedule won't rebuild it for newer libopus; dispatch `-f tool=opus-tools -f force=true` to refresh. The fdkaac build always takes the newest libfdk-aac tag at build time. SoX is a minimal build (no MP3/FLAC/Ogg formats).

## Visibility

This repo is **private** for now, to match RenderForge. Release assets in a private repo can't be downloaded anonymously, so **RenderForge end users can't download from it**. Before RenderForge ships the Encoder Manager, either make this repo public (which also makes Actions minutes free) or mirror the release assets to a public host.
