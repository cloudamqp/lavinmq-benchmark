#!/usr/bin/env python3
"""Aggregate raw benchmark CSVs into one JSON per scenario.

Outputs:
    results/throughput.json
    results/latency.json
    results/mqtt_throughput.json

Each file holds median-across-runs values per (instance, size[, rate_limit]),
ready for a single fetch by the website. Raw CSVs stay at their original
paths for anyone who wants per-run detail.
"""

from __future__ import annotations

import csv
import datetime as dt
import json
import re
import statistics
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RESULTS = ROOT / "results"
SCENARIOS = ("throughput", "latency", "mqtt_throughput")
VERSION_RE = re.compile(r"^v\d+\.\d+\.\d+$")
PRE_VERSION_RE = re.compile(r"^v\d+\.\d+\.\d+[-.].+$")


def version_sort_key(name: str) -> tuple:
    core = name.split("-", 1)[0].lstrip("v")
    return tuple(int(p) if p.isdigit() else 0 for p in core.split("."))


def instance_from_filename(name: str) -> str:
    return name.split("_", 1)[0].replace("-", ".")


def median(values: list) -> float | None:
    nums = [v for v in values if v is not None]
    return statistics.median(nums) if nums else None


def scan(vdir: Path, version: str) -> list[tuple[str, str, Path]]:
    """Yield (scenario, instance, csv_path) for every CSV under vdir."""
    out = []
    for scenario in SCENARIOS:
        sdir = vdir / scenario
        if not sdir.is_dir():
            continue
        for csv_path in sorted(sdir.glob("*.csv")):
            out.append((scenario, instance_from_filename(csv_path.name), csv_path))
    return out


def aggregate_throughput(version: str, instance: str, csv_path: Path) -> list[dict]:
    with csv_path.open(newline="") as fh:
        rows = list(csv.DictReader(fh))
    by_size: dict[int, list[dict]] = defaultdict(list)
    for r in rows:
        by_size[int(r["Size"])].append({
            "pub_rate": int(r["PubRate"]),
            "con_rate": int(r["ConRate"]),
            "pub_bw":   float(r["PubBW"]),
            "con_bw":   float(r["ConBW"]),
        })
    return [{
        "version": version, "instance": instance, "size": size,
        "pub_rate": median([r["pub_rate"] for r in runs]),
        "con_rate": median([r["con_rate"] for r in runs]),
        "pub_bw":   median([r["pub_bw"]   for r in runs]),
        "con_bw":   median([r["con_bw"]   for r in runs]),
    } for size, runs in sorted(by_size.items())]


def aggregate_latency(version: str, instance: str, csv_path: Path) -> list[dict]:
    with csv_path.open(newline="") as fh:
        rows = list(csv.DictReader(fh))
    by_key: dict[tuple[int, int], list[dict]] = defaultdict(list)
    for r in rows:
        by_key[(int(r["Size"]), int(r["RateLimit"]))].append({
            "min":      float(r["Min"]),
            "median":   float(r["Median"]),
            "p75":      float(r["P75"]),
            "p95":      float(r["P95"]),
            "p99":      float(r["P99"]),
            "pub_rate": int(r["PubRate"]),
        })
    return [{
        "version": version, "instance": instance,
        "size": size, "rate_limit": rate,
        "min":      median([r["min"]      for r in runs]),
        "median":   median([r["median"]   for r in runs]),
        "p75":      median([r["p75"]      for r in runs]),
        "p95":      median([r["p95"]      for r in runs]),
        "p99":      median([r["p99"]      for r in runs]),
        "pub_rate": median([r["pub_rate"] for r in runs]),
    } for (size, rate), runs in sorted(by_key.items())]


def collect_entries() -> list[tuple[str, str, str, Path]]:
    """List of (version, scenario, instance, csv_path) across all version dirs."""
    entries = []
    for path in sorted(RESULTS.iterdir()):
        if not path.is_dir():
            continue
        if VERSION_RE.match(path.name):
            for scenario, instance, csv_path in scan(path, path.name):
                entries.append((path.name, scenario, instance, csv_path))
        elif path.name == "pre-release":
            for sub in sorted(path.iterdir()):
                if sub.is_dir() and PRE_VERSION_RE.match(sub.name):
                    for scenario, instance, csv_path in scan(sub, sub.name):
                        entries.append((sub.name, scenario, instance, csv_path))
    return entries


def main() -> None:
    entries = collect_entries()
    versions = sorted({v for v, _, _, _ in entries}, key=version_sort_key)
    generated_at = dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds")

    for scenario in SCENARIOS:
        aggregator = aggregate_latency if scenario == "latency" else aggregate_throughput
        rows = []
        for v, s, inst, path in entries:
            if s == scenario:
                rows += aggregator(v, inst, path)
        target = RESULTS / f"{scenario}.json"
        target.write_text(json.dumps({
            "generated_at": generated_at,
            "scenario": scenario,
            "versions": versions,
            "data": rows,
        }, separators=(",", ":")) + "\n")
        print(f"wrote {target.relative_to(ROOT)} "
              f"({len(rows)} rows, {target.stat().st_size / 1024:.1f} KB)")


if __name__ == "__main__":
    main()
