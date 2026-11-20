# renderforge-tools

Windows x64 builds of video and audio encoders that **have no official Windows binaries**, built unmodified from upstream release tags and published as GitHub Releases. The [RenderForge](https://github.com/Dranzer94/RenderForge) Encoder Manager downloads them after install, so the RenderForge installer never bundles third-party encoders.

Tools with good official Windows builds (FFmpeg via BtbN, x264 via VideoLAN, MKVToolNix, MediaInfo, FLAC, rav1e and so on) are **not** built here; the Encoder Manager downloads those from their own publishers.

## What is built

| Tool | Upstream | Output | Status |
| --- | --- | --- | --- |
| x265 | [multicoreware/x265_git](https://bitbucket.org/multicoreware/x265_git) numeric tags (`4.2`) | `x265.exe`, static, 8/10/12-bit multilib | in workflow |
| SVT-AV1 | [AOMediaCodec/SVT-AV1](https://gitlab.com/AOMediaCodec/SVT-AV1) `vX.Y.Z` tags | `SvtAv1EncApp.exe`, static | in workflow |
| aomenc | libaom | `aomenc.exe` | planned |
| dav1d | VideoLAN dav1d | `dav1d.exe` | planned |
| vpxenc | libvpx | `vpxenc.exe` | planned |
| vvenc | Fraunhofer vvenc | `vvencapp.exe` | planned |
| others | uvg266, exhale, LAME, newer opus-tools, … | | planned, as the RenderForge catalogue needs them |

## Release layout (the contract RenderForge relies on)

- One release per tool and upstream version. Tag: `<tool>-<version>`, for example `x265-4.2` or `svt-av1-4.3.1`.
- Assets:
  - `<tool>-<version>-win64.zip`: the exe, the upstream licence file(s), `version.txt` (the exe's own `--version` output) and `BUILDINFO.txt` (upstream tag and commit, compiler, link to the build log).
  - `checksums.sha256`: `sha256sum` output for the zip.
- The release notes link to the upstream changelog and source tree.
- Releases are created with `--latest=false`, so do not use `/releases/latest`. RenderForge lists releases and picks the newest tag with the tool's prefix.

## How builds run

`.github/workflows/build.yml`:

1. **plan** (Ubuntu): `scripts/plan.py` reads upstream tags with `git ls-remote`, and keeps only tools whose `<tool>-<version>` release does not exist yet (or all of them when `force` is set).
2. **build** (windows-latest, one job per tool): MSYS2 UCRT64 with GCC, CMake, Ninja and NASM, `scripts/build-<tool>.sh`. It then checks the exe does not need MSYS2 DLLs, zips it, writes the checksum and publishes the release.

Triggers:

- **Weekly schedule** (Mondays 04:17 UTC): builds any new upstream tag.
- **Manual**: Actions → Build tools → Run workflow, or
  `gh workflow run build.yml -f tool=x265 -f version=4.1 -f force=true`.

## Adding a tool

1. Add an entry to `TOOLS` in `scripts/plan.py` (git URL, tag regex, changelog URL).
2. Add `scripts/build-<tool>.sh <git-url> <ref> <out-dir>` that leaves a static exe plus licence file(s) in `<out-dir>`.
3. Add the tool id to the `tool` choice list in the workflow.
4. Add or update its licence notes in [LICENSES.md](LICENSES.md).
5. Point the tool's RenderForge catalogue entry (`data/encoders.json`, source type `curated`) at this repo with `tag_prefix: "<tool>-"`.

## Visibility

This repo is **private** for now, to match RenderForge. Release assets in a private repo can't be downloaded anonymously, so **RenderForge end users can't download from it**. Before RenderForge ships the Encoder Manager, either make this repo public (which also makes Actions minutes free) or mirror the release assets to a public host.
