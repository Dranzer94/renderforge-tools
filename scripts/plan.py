#!/usr/bin/env python3
"""Decide which tools need a new build.

Reads the latest upstream release tag for every tool in TOOLS, compares it with
this repo's releases (tag "<tool>-<version>") and writes a GitHub Actions matrix
to $GITHUB_OUTPUT. Inputs come from environment variables:

  INPUT_TOOL     "all" or one tool id (default "all")
  INPUT_VERSION  upstream version override, only used when INPUT_TOOL is a single tool
  INPUT_FORCE    "true" to rebuild even if the release already exists
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys

TOOLS = {
    "x265": {
        "git": "https://bitbucket.org/multicoreware/x265_git.git",
        "tag_regex": r"^(\d+\.\d+(?:\.\d+)?)$",
        "ref_template": "{version}",
        "notes_url": "https://x265.readthedocs.io/en/master/releasenotes.html",
        "source_url": "https://bitbucket.org/multicoreware/x265_git/src/{ref}/",
    },
    "svt-av1": {
        "git": "https://github.com/AOMediaCodec/SVT-AV1.git",
        "tag_regex": r"^v(\d+\.\d+\.\d+)$",
        "ref_template": "v{version}",
        "notes_url": "https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/v{version}/CHANGELOG.md",
        "source_url": "https://gitlab.com/AOMediaCodec/SVT-AV1/-/tree/v{version}",
    },
}


def _version_key(version: str) -> tuple[int, ...]:
    return tuple(int(part) for part in version.split("."))


def latest_upstream_version(tool: str) -> str:
    spec = TOOLS[tool]
    out = subprocess.run(
        ["git", "ls-remote", "--tags", "--refs", spec["git"]],
        check=True, capture_output=True, text=True,
    ).stdout
    pattern = re.compile(spec["tag_regex"])
    versions = []
    for line in out.splitlines():
        tag = line.split("refs/tags/", 1)[-1].strip()
        match = pattern.match(tag)
        if match:
            versions.append(match.group(1))
    if not versions:
        raise SystemExit(f"{tool}: no upstream tags matched {spec['tag_regex']}")
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
    tools = list(TOOLS) if wanted == "all" else [wanted]
    include = []
    for tool in tools:
        if tool not in TOOLS:
            raise SystemExit(f"unknown tool {tool!r}")
        version = override if (override and wanted != "all") else latest_upstream_version(tool)
        tag = f"{tool}-{version}"
        exists = release_exists(tag)
        print(f"{tool}: upstream {version}, release {tag} {'exists' if exists else 'missing'}")
        if exists and not force:
            continue
        spec = TOOLS[tool]
        ref = spec["ref_template"].format(version=version)
        include.append({
            "tool": tool,
            "version": version,
            "ref": ref,
            "tag": tag,
            "git": spec["git"],
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
