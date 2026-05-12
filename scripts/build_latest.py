#!/usr/bin/env python3
"""Emit results/latest.json: the latest stable LavinMQ version's throughput
medians per (instance, message size), for use by lavinmq.com/benchmark.

Shape:
    {
      "version": "v2.8.0",
      "result_date": "2026-05-07",
      "generated_at": "...",
      "scenario": "throughput",
      "instances": {
        "c7a.large": {
          "sizes": {
            "16":    {"pub_rate": ..., "con_rate": ...},
            "64":    {...},
            ...
          }
        },
        ...
      }
    }
"""

from __future__ import annotations

import csv
import datetime as dt
import json
import re
import statistics
import subprocess
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RESULTS = ROOT / "results"
VERSION_RE = re.compile(r"^v\d+\.\d+\.\d+$")


def version_sort_key(name: str) -> tuple:
    core = name.lstrip("v").split("-", 1)[0]
    return tuple(int(p) if p.isdigit() else 0 for p in core.split("."))


def instance_from_filename(name: str) -> str:
    return name.split("_", 1)[0].replace("-", ".")


def median_int(values: list[int]) -> int | None:
    return int(statistics.median(values)) if values else None


def latest_stable_version() -> str:
    versions = [p.name for p in RESULTS.iterdir()
                if p.is_dir() and VERSION_RE.match(p.name)]
    if not versions:
        raise SystemExit("no stable version directories found under results/")
    return max(versions, key=version_sort_key)


def aggregate(vdir: Path) -> dict[str, dict]:
    instances: dict[str, dict] = {}
    src = vdir / "throughput"
    if not src.is_dir():
        return instances
    for csv_path in sorted(src.glob("*.csv")):
        by_size: dict[int, list[dict]] = defaultdict(list)
        with csv_path.open(newline="") as fh:
            for r in csv.DictReader(fh):
                by_size[int(r["Size"])].append(r)
        sizes: dict[str, dict] = {}
        for size, runs in sorted(by_size.items()):
            sizes[str(size)] = {
                "pub_rate": median_int([int(r["PubRate"]) for r in runs]),
                "con_rate": median_int([int(r["ConRate"]) for r in runs]),
            }
        instances[instance_from_filename(csv_path.name)] = {"sizes": sizes}
    return instances


def result_date(vdir: Path) -> str | None:
    """Date the version's results were committed to the repo (YYYY-MM-DD)."""
    try:
        out = subprocess.check_output(
            ["git", "log", "-1", "--format=%cI", "--", str(vdir)],
            cwd=ROOT, text=True,
        ).strip()
        return out.split("T")[0] if out else None
    except subprocess.CalledProcessError:
        return None


def main() -> None:
    version = latest_stable_version()
    vdir = RESULTS / version
    instances = aggregate(vdir)
    payload = {
        "version": version,
        "result_date": result_date(vdir),
        "generated_at": dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds"),
        "scenario": "throughput",
        "instances": instances,
    }
    target = RESULTS / "latest.json"
    target.write_text(json.dumps(payload, indent=2) + "\n")
    n_sizes = sum(len(i["sizes"]) for i in instances.values())
    print(f"wrote {target.relative_to(ROOT)} "
          f"(version={version}, {len(instances)} instances, "
          f"{n_sizes} (instance, size) rows, "
          f"result_date={payload['result_date']})")


if __name__ == "__main__":
    main()
