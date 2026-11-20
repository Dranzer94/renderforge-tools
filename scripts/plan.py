#!/usr/bin/env python3
"""Decide which tools need a new build.

Reads the latest upstream release version for every tool in TOOLS, compares it
with this repo's releases (tag "<tool>-<version>") and writes a GitHub Actions
matrix to $GITHUB_OUTPUT. Inputs come from environment variables:

  INPUT_TOOL     "all", "standard", or one tool id (default "all"); a comma list also works
  INPUT_VERSION  upstream version override, only used when INPUT_TOOL is a single tool
  INPUT_FORCE    "true" to rebuild even if the release already exists

Each TOOLS entry:
  version   how to find the newest upstream version:
            {"git": url, "regex": r"..."}  newest tag matching regex (group 1 = version)
            {"http": url, "regex": r"..."} newest regex match in a web page/feed
  src       what the build script fetches: a git URL, or a tarball URL template
  ref       git tag template (ignored for tarballs; the version is passed instead)
  pkgs      extra MSYS2 UCRT64 packages (pacboy names, ":p" suffix) for this tool
  notes_url, source_url   templates for the release notes
  optin     True for tools with licence restrictions; their releases are labelled
            as opt-in and they are skipped by "standard" (but included in "all")
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys
import urllib.request

SEMVER = r"(\d+\.\d+(?:\.\d+){0,2})"

TOOLS: dict[str, dict] = {
    "x265": {
        "version": {"git": "https://bitbucket.org/multicoreware/x265_git.git", "regex": rf"^{SEMVER}$"},
        "src": "https://bitbucket.org/multicoreware/x265_git.git",
        "ref": "{version}",
        "notes_url": "https://x265.readthedocs.io/en/master/releasenotes.html",
        "source_url": "https://bitbucket.org/multicoreware/x265_git/src/{version}/",
    },
    "svt-av1": {
        "version": {"git": "https://github.com/AOMediaCodec/SVT-AV1.git", "regex": rf"^v{SEMVER}$"},
        "src": "https://github.com/AOMediaCodec/SVT-AV1.git",
        "ref": "v{version}",
        "notes_url": "https://github.com/AOMediaCodec/SVT-AV1/blob/v{version}/CHANGELOG.md",
        "source_url": "https://github.com/AOMediaCodec/SVT-AV1/tree/v{version}",
    },
    "aom": {
        "version": {"git": "https://aomedia.googlesource.com/aom", "regex": rf"^v{SEMVER}$"},
        "src": "https://aomedia.googlesource.com/aom",
        "ref": "v{version}",
        "pkgs": "perl:p",
        "notes_url": "https://aomedia.googlesource.com/aom/+/refs/tags/v{version}/CHANGELOG",
        "source_url": "https://aomedia.googlesource.com/aom/+/refs/tags/v{version}",
    },
    "dav1d": {
        "version": {"git": "https://code.videolan.org/videolan/dav1d.git", "regex": rf"^{SEMVER}$"},
        "src": "https://code.videolan.org/videolan/dav1d.git",
        "ref": "{version}",
        "pkgs": "meson:p",
        "notes_url": "https://code.videolan.org/videolan/dav1d/-/blob/{version}/NEWS",
        "source_url": "https://code.videolan.org/videolan/dav1d/-/tree/{version}",
    },
    "vpx": {
        "version": {"git": "https://chromium.googlesource.com/webm/libvpx", "regex": rf"^v{SEMVER}$"},
        "src": "https://chromium.googlesource.com/webm/libvpx",
        "ref": "v{version}",
        "notes_url": "https://chromium.googlesource.com/webm/libvpx/+/refs/tags/v{version}/CHANGELOG",
        "source_url": "https://chromium.googlesource.com/webm/libvpx/+/refs/tags/v{version}",
    },
    "uvg266": {
        "version": {"git": "https://github.com/ultravideo/uvg266.git", "regex": rf"^v{SEMVER}$"},
        "src": "https://github.com/ultravideo/uvg266.git",
        "ref": "v{version}",
        "notes_url": "https://github.com/ultravideo/uvg266/releases/tag/v{version}",
        "source_url": "https://github.com/ultravideo/uvg266/tree/v{version}",
    },
    "vvenc": {
        "version": {"git": "https://github.com/fraunhoferhhi/vvenc.git", "regex": rf"^v{SEMVER}$"},
        "src": "https://github.com/fraunhoferhhi/vvenc.git",
        "ref": "v{version}",
        "notes_url": "https://github.com/fraunhoferhhi/vvenc/blob/v{version}/changelog.txt",
        "source_url": "https://github.com/fraunhoferhhi/vvenc/tree/v{version}",
    },
    "vvdec": {
        "version": {"git": "https://github.com/fraunhoferhhi/vvdec.git", "regex": rf"^v{SEMVER}$"},
        "src": "https://github.com/fraunhoferhhi/vvdec.git",
        "ref": "v{version}",
        "notes_url": "https://github.com/fraunhoferhhi/vvdec/blob/v{version}/changelog.txt",
        "source_url": "https://github.com/fraunhoferhhi/vvdec/tree/v{version}",
    },
    "svt-hevc": {
        "version": {"git": "https://github.com/OpenVisualCloud/SVT-HEVC.git", "regex": rf"^v{SEMVER}$"},
        "src": "https://github.com/OpenVisualCloud/SVT-HEVC.git",
        "ref": "v{version}",
        "notes_url": "https://github.com/OpenVisualCloud/SVT-HEVC/releases/tag/v{version}",
        "source_url": "https://github.com/OpenVisualCloud/SVT-HEVC/tree/v{version}",
    },
    "svt-vp9": {
        "version": {"git": "https://github.com/OpenVisualCloud/SVT-VP9.git", "regex": rf"^v{SEMVER}$"},
        "src": "https://github.com/OpenVisualCloud/SVT-VP9.git",
        "ref": "v{version}",
        "notes_url": "https://github.com/OpenVisualCloud/SVT-VP9/releases/tag/v{version}",
        "source_url": "https://github.com/OpenVisualCloud/SVT-VP9/tree/v{version}",
    },
    "xvid": {
        "version": {"http": "https://downloads.xvid.com/downloads/", "regex": r"xvidcore-(\d+\.\d+\.\d+)\.tar\.gz"},
        "src": "https://downloads.xvid.com/downloads/xvidcore-{version}.tar.gz",
        "ref": "{version}",
        "notes_url": "https://www.xvid.com/download/",
        "source_url": "https://downloads.xvid.com/downloads/xvidcore-{version}.tar.gz",
    },
    "lame": {
        "version": {"http": "https://sourceforge.net/projects/lame/rss?path=/lame",
                    "regex": r"/lame/(\d+\.\d+(?:\.\d+)?)/lame-\1\.tar\.gz"},
        "src": "https://downloads.sourceforge.net/project/lame/lame/{version}/lame-{version}.tar.gz",
        "ref": "{version}",
        "pkgs": "mpg123:p",
        "notes_url": "https://lame.sourceforge.io/news.php",
        "source_url": "https://sourceforge.net/projects/lame/files/lame/{version}/",
    },
    "exhale": {
        "version": {"git": "https://gitlab.com/ecodis/exhale.git", "regex": rf"^v{SEMVER}$"},
        "src": "https://gitlab.com/ecodis/exhale.git",
        "ref": "v{version}",
        "notes_url": "https://gitlab.com/ecodis/exhale/-/blob/v{version}/README.md",
        "source_url": "https://gitlab.com/ecodis/exhale/-/tree/v{version}",
    },
    "speex": {
        "version": {"git": "https://gitlab.xiph.org/xiph/speex.git", "regex": r"^Speex-(\d+\.\d+\.\d+)$"},
        "src": "https://downloads.xiph.org/releases/speex/speex-{version}.tar.gz",
        "ref": "{version}",
        "pkgs": "libogg:p",
        "notes_url": "https://gitlab.xiph.org/xiph/speex/-/blob/Speex-{version}/ChangeLog",
        "source_url": "https://downloads.xiph.org/releases/speex/speex-{version}.tar.gz",
    },
    "vorbis-tools": {
        "version": {"git": "https://gitlab.xiph.org/xiph/vorbis-tools.git", "regex": rf"^v{SEMVER}$"},
        "src": "https://downloads.xiph.org/releases/vorbis/vorbis-tools-{version}.tar.gz",
        "ref": "{version}",
        "pkgs": "libogg:p libvorbis:p",
        "notes_url": "https://gitlab.xiph.org/xiph/vorbis-tools/-/blob/v{version}/CHANGES",
        "source_url": "https://downloads.xiph.org/releases/vorbis/vorbis-tools-{version}.tar.gz",
    },
    "sox": {
        "version": {"http": "https://sourceforge.net/projects/sox/rss?path=/sox",
                    "regex": r"/sox/(\d+\.\d+\.\d+)/sox-\1\.tar\.gz"},
        "src": "https://downloads.sourceforge.net/project/sox/sox/{version}/sox-{version}.tar.gz",
        "ref": "{version}",
        "notes_url": "https://sourceforge.net/p/sox/code/ci/master/tree/ChangeLog",
        "source_url": "https://sourceforge.net/projects/sox/files/sox/{version}/",
    },
    "opus-tools": {
        "version": {"git": "https://gitlab.xiph.org/xiph/opus-tools.git", "regex": rf"^v{SEMVER}$"},
        "src": "https://downloads.xiph.org/releases/opus/opus-tools-{version}.tar.gz",
        "ref": "{version}",
        "pkgs": "libogg:p opus:p opusfile:p libopusenc:p flac:p",
        "notes_url": "https://gitlab.xiph.org/xiph/opus-tools/-/tags/v{version}",
        "source_url": "https://downloads.xiph.org/releases/opus/opus-tools-{version}.tar.gz",
    },
    "webp": {
        "version": {"git": "https://chromium.googlesource.com/webm/libwebp", "regex": rf"^v{SEMVER}$"},
        "src": "https://chromium.googlesource.com/webm/libwebp",
        "ref": "v{version}",
        "pkgs": "libpng:p libjpeg-turbo:p zlib:p",
        "notes_url": "https://chromium.googlesource.com/webm/libwebp/+/refs/tags/v{version}/NEWS",
        "source_url": "https://chromium.googlesource.com/webm/libwebp/+/refs/tags/v{version}",
    },
    "fdkaac": {
        "version": {"git": "https://github.com/nu774/fdkaac.git", "regex": rf"^v{SEMVER}$"},
        "src": "https://github.com/nu774/fdkaac.git",
        "ref": "v{version}",
        "pkgs": "autotools:p",
        "optin": True,
        "notes_url": "https://github.com/nu774/fdkaac/blob/v{version}/ChangeLog",
        "source_url": "https://github.com/nu774/fdkaac/tree/v{version} (front end) and https://github.com/mstorsjo/fdk-aac (library)",
    },
}

BASE_PKGS = "toolchain:p cmake:p ninja:p nasm:p pkgconf:p"


def _version_key(version: str) -> tuple[int, ...]:
    return tuple(int(part) for part in version.split("."))


def _git_versions(url: str, regex: str) -> list[str]:
    out = subprocess.run(
        ["git", "ls-remote", "--tags", "--refs", url],
        check=True, capture_output=True, text=True, timeout=120,
    ).stdout
    pattern = re.compile(regex)
    found = []
    for line in out.splitlines():
        tag = line.split("refs/tags/", 1)[-1].strip()
        match = pattern.match(tag)
        if match:
            found.append(match.group(1))
    return found


def _http_versions(url: str, regex: str) -> list[str]:
    req = urllib.request.Request(url, headers={"User-Agent": "renderforge-tools-plan"})
    with urllib.request.urlopen(req, timeout=60) as resp:
        text = resp.read().decode("utf-8", "replace")
    return [m.group(1) for m in re.finditer(regex, text)]


def latest_upstream_version(tool: str) -> str:
    spec = TOOLS[tool]["version"]
    if "git" in spec:
        versions = _git_versions(spec["git"], spec["regex"])
    else:
        versions = _http_versions(spec["http"], spec["regex"])
    if not versions:
        raise RuntimeError(f"{tool}: no upstream versions matched {spec['regex']}")
    return max(versions, key=_version_key)


def release_exists(tag: str) -> bool:
    result = subprocess.run(
        ["gh", "release", "view", tag, "--repo", os.environ["GITHUB_REPOSITORY"]],
        capture_output=True, text=True,
    )
    return result.returncode == 0


def main() -> int:
    wanted = (os.environ.get("INPUT_TOOL") or "all").strip()
    override = (os.environ.get("INPUT_VERSION") or "").strip()
    force = (os.environ.get("INPUT_FORCE") or "false").lower() == "true"
    if wanted == "all":
        tools = list(TOOLS)
    elif wanted == "standard":
        tools = [t for t in TOOLS if not TOOLS[t].get("optin")]
    else:
        tools = [t.strip() for t in wanted.split(",") if t.strip()]
    single = len(tools) == 1 and wanted not in ("all", "standard")
    include = []
    for tool in tools:
        if tool not in TOOLS:
            raise SystemExit(f"unknown tool {tool!r}")
        try:
            version = override if (override and single) else latest_upstream_version(tool)
        except Exception as exc:  # one broken upstream must not block the others
            print(f"::warning::{tool}: upstream version lookup failed: {exc}")
            continue
        tag = f"{tool}-{version}"
        exists = release_exists(tag)
        print(f"{tool}: upstream {version}, release {tag} {'exists' if exists else 'missing'}")
        if exists and not force:
            continue
        spec = TOOLS[tool]
        ref = spec["ref"].format(version=version)
        include.append({
            "tool": tool,
            "version": version,
            "ref": ref,
            "tag": tag,
            "src": spec["src"].format(version=version),
            "pkgs": f"{BASE_PKGS} {spec.get('pkgs', '')}".strip(),
            "optin": bool(spec.get("optin")),
            "notes_url": spec["notes_url"].format(version=version, ref=ref),
            "source_url": spec["source_url"].format(version=version, ref=ref),
        })
    matrix = json.dumps({"include": include})
    print(matrix)
    with open(os.environ.get("GITHUB_OUTPUT", "/dev/stdout"), "a", encoding="utf-8") as fh:
        fh.write(f"matrix={matrix}\n")
        fh.write(f"any={'true' if include else 'false'}\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
