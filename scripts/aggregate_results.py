#!/usr/bin/env python3
"""
Aggregate per-instance benchmark result files into summary markdown files.

Usage:
    python aggregate_results.py \\
        --version 2.7.0-rc.3 \\
        --latency-dir  ./raw-results/latency \\
        --throughput-dir ./raw-results/throughput \\
        --output-dir results
"""

import argparse
import csv
import json
import os
import re
import shutil
import statistics
from pathlib import Path

# ---------------------------------------------------------------------------
# Instance metadata: slug -> (display_name, description)
# slug uses dashes, matching the artifact/file naming convention.
# ---------------------------------------------------------------------------
INSTANCE_META = {
    "t4g-micro":  ("t4g.micro",  "2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)"),
    "t4g-small":  ("t4g.small",  "2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)"),
    "t4g-medium": ("t4g.medium", "2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)"),
    "r7g-medium": ("r7g.medium", "1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)"),
    "r7g-large":  ("r7g.large",  "2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)"),
    "r7g-xlarge": ("r7g.xlarge", "4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)"),
    "c8g-large":  ("c8g.large",  "2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)"),
    "c7a-large":  ("c7a.large",  "2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)"),
    "i8g-large":  ("i8g.large",  "2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)"),
    "i7i-large":  ("i7i.large",  "2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)"),
    "z1d-large":  ("z1d.large",  "2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)"),
}

# Display order: group name -> list of slugs
INSTANCE_GROUPS = [
    ("Burstable General-Purpose",      ["t4g-micro", "t4g-small", "t4g-medium"]),
    ("Memory Optimized",               ["r7g-medium", "r7g-large", "r7g-xlarge"]),
    ("CPU Optimized",                  ["c8g-large", "c7a-large"]),
    ("Storage Optimized",              ["i8g-large", "i7i-large"]),
    ("High Single-Threaded Performance", ["z1d-large"]),
]


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def slug_from_filename(path: Path, suffix: str) -> str:
    """
    'c8g-large_latency.md' -> 'c8g-large'
    Handles dots in original matrix.broker names that GitHub Actions may have
    kept or replaced with dashes.
    """
    name = path.stem  # strip .md
    if name.endswith(suffix):
        name = name[: -len(suffix)]
    # normalise dots to dashes
    return name.replace(".", "-").rstrip("-_")


def fmt_num(value: str) -> str:
    """Format an integer string with thousand separators: '994301' -> '994,301'."""
    try:
        return f"{int(value):,}"
    except (ValueError, TypeError):
        return str(value)


def fmt_float(value: str, decimals: int = 2) -> str:
    try:
        return f"{float(value):.{decimals}f}"
    except (ValueError, TypeError):
        return str(value)


# ---------------------------------------------------------------------------
# Latency parsing
# ---------------------------------------------------------------------------

def parse_latency_files(csv_path: Path, json_path: Path) -> dict:
    """
    Parse per-instance latency results from CSV + JSON config files produced
    by run_multiple_latency_tests.sh.

    Returns the same dict shape as the former parse_latency_file():
        {
          "instance_type": str,
          "lavinmq_version": str,
          "duration": str,
          "sizes": [int, ...],
          "data": {
            size_int: {
              rate_int: {
                "min": str, "median": str, "p75": str, "p95": str, "p99": str,
                "pub_rate": str, "pub_bw": str, "con_bw": str
              }
            }
          }
        }
    """
    with json_path.open() as f:
        cfg = json.load(f)

    result: dict = {
        "instance_type":   cfg.get("instance_type", ""),
        "lavinmq_version": cfg.get("lavinmq_version", ""),
        "duration":        str(cfg.get("duration", "")),
        "sizes":           [int(s) for s in cfg.get("sizes", [])],
        "data":            {},
    }

    # Group rows by (size, rate_limit)
    groups: dict = {}
    with csv_path.open(newline="") as f:
        for row in csv.DictReader(f):
            key = (int(row["Size"]), int(row["RateLimit"]))
            groups.setdefault(key, []).append(row)

    for (size, rate), rows in groups.items():
        result["data"].setdefault(size, {})[rate] = {
            "min":      f"{statistics.median(float(r['Min'])      for r in rows):.2f}",
            "median":   f"{statistics.median(float(r['Median'])   for r in rows):.2f}",
            "p75":      f"{statistics.median(float(r['P75'])      for r in rows):.2f}",
            "p95":      f"{statistics.median(float(r['P95'])      for r in rows):.2f}",
            "p99":      f"{statistics.median(float(r['P99'])      for r in rows):.2f}",
            "pub_rate": str(round(statistics.median(float(r['PubRate']) for r in rows))),
            "pub_bw":   f"{statistics.median(float(r['PubBW'])    for r in rows):.2f}",
            "con_bw":   f"{statistics.median(float(r['ConBW'])    for r in rows):.2f}",
        }

    return result


# ---------------------------------------------------------------------------
# Throughput parsing
# ---------------------------------------------------------------------------

def parse_throughput_files(csv_path: Path, json_path: Path) -> dict:
    """
    Parse per-instance throughput results from CSV + JSON config files produced
    by run_multiple_throughput_tests.sh.

    Returns the same dict shape as the former parse_throughput_file():
        {
          "instance_type": str,
          "lavinmq_version": str,
          "duration": str,
          "data": {
            size_int: {
              "pub_rate": str, "con_rate": str, "pub_bw": str, "con_bw": str
            }
          }
        }
    """
    with json_path.open() as f:
        cfg = json.load(f)

    result: dict = {
        "instance_type":   cfg.get("instance_type", ""),
        "lavinmq_version": cfg.get("lavinmq_version", ""),
        "duration":        str(cfg.get("duration", "")),
        "data":            {},
    }

    groups: dict = {}
    with csv_path.open(newline="") as f:
        for row in csv.DictReader(f):
            key = int(row["Size"])
            groups.setdefault(key, []).append(row)

    for size, rows in groups.items():
        result["data"][size] = {
            "pub_rate": str(round(statistics.median(float(r['PubRate']) for r in rows))),
            "con_rate": str(round(statistics.median(float(r['ConRate']) for r in rows))),
            "pub_bw":   f"{statistics.median(float(r['PubBW']) for r in rows):.2f}",
            "con_bw":   f"{statistics.median(float(r['ConBW']) for r in rows):.2f}",
        }

    return result


# ---------------------------------------------------------------------------
# Latency summary builders
# ---------------------------------------------------------------------------

def build_latency_summary(
    parsed: dict,           # slug -> parse_latency_file result
    version: str,
    percentile: str,        # "p95" or "p99"
    col_label: str,         # "P95" or "P99"
) -> str:
    # Collect all sizes and rates seen across all instances
    all_sizes: list[int] = sorted({
        s for p in parsed.values() for s in p["data"]
    })
    all_rates: list[int] = sorted({
        r for p in parsed.values() for s in p["data"].values() for r in s
    })

    lines = []
    lines.append(f"# LavinMQ {col_label} Latency Results\n")
    lines.append(
        f"***Important***: These results are from {next(iter(parsed.values()))['duration']}s "
        "test runs per instance type. Anomalies may be due to transient network conditions, "
        "CPU throttling/bursting, background system processes, or queue state variations.\n"
    )
    lines.append("## Benchmark Setup\n")
    lines.append(
        "- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)\n"
        "- Benchmark-broker (AWS instance, public IP)\n"
        "- Benchmark-loadgen (AWS instance, public IP)\n"
        "\nLoad generator -> AMQP-URL (broker private IP) -> Broker\n"
    )
    lines.append("## Table Headers\n")
    lines.append(
        "- **Rate limit**: Rate limit in msgs/s\n"
        f"- **Message Sizes**: {', '.join(str(s) for s in all_sizes)} bytes\n"
    )
    lines.append("## AWS Instance Types\n")
    lines.append(
        f"Benchmark results for AWS instance types with LavinMQ version v{version}.\n"
    )

    duration = next(iter(parsed.values()), {}).get("duration", "20")
    lines.append("```shell")
    lines.append(f"lavinmqperf throughput -z {duration} -x 1 -y 1 -s <size> -r <rate-limit> --measure-latency")
    lines.append("```\n")

    size_headers = " | ".join(f"{s} bytes" for s in all_sizes)
    size_sep = " | ".join("---------:" for _ in all_sizes)
    header_row = f"| Rate Limit | {size_headers} |"
    sep_row    = f"|-----------:| {size_sep} |"

    for group_name, slugs in INSTANCE_GROUPS:
        group_instances = [(s, parsed[s]) for s in slugs if s in parsed]
        if not group_instances:
            continue
        lines.append(f"### {group_name}\n")
        for slug, p in group_instances:
            display, desc = INSTANCE_META.get(slug, (slug, ""))
            lines.append(f"**{display}** - {desc}\n")
            lines.append(header_row)
            lines.append(sep_row)
            for rate in all_rates:
                cells = []
                for size in all_sizes:
                    val = p["data"].get(size, {}).get(rate, {}).get(percentile, "")
                    cells.append(f"{fmt_float(val):>9}" if val else "        -")
                rate_fmt = fmt_num(str(rate))
                lines.append(f"| {rate_fmt:>10} | {' | '.join(cells)} |")
            lines.append("")

    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Throughput summary builder
# ---------------------------------------------------------------------------

def build_throughput_summary(parsed: dict, version: str) -> str:
    all_sizes: list[int] = sorted({
        s for p in parsed.values() for s in p["data"]
    })

    lines = []
    lines.append("# LavinMQ Throughput Results\n")
    lines.append("## Benchmark Setup\n")
    lines.append(
        "- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)\n"
        "- Benchmark-broker (AWS instance, public IP)\n"
        "- Benchmark-loadgen (AWS instance, public IP)\n"
        "\nLoad generator -> AMQP-URL (broker private IP) -> Broker\n"
    )
    lines.append("## Table Headers\n")
    lines.append(
        "- **Size**: Message size in bytes\n"
        "- **Avg. Publish Rate**: Average publish rate in msgs/s\n"
        "- **Avg. Consume Rate**: Average consume rate in msgs/s\n"
        "- **Publish BW**: Publish bandwidth in MiB/s\n"
        "- **Consume BW**: Consume bandwidth in MiB/s\n"
    )
    lines.append("## AWS Instance Types\n")
    duration = next(iter(parsed.values()), {}).get("duration", "60")
    lines.append(f"Benchmark results for AWS instance types with LavinMQ version v{version}.\n")
    lines.append("```shell")
    lines.append(f"lavinmqperf throughput -z {duration} -x 1 -y 1 -s <size>")
    lines.append("```\n")

    header_row = "| {:>5} | {:>17} | {:>17} | {:>11} | {:>11} |".format(
        "Size", "Avg. Publish Rate", "Avg. Consume Rate", "Publish BW", "Consume BW"
    )
    sep_row = "|------:|------------------:|------------------:|------------:|------------:|"

    for group_name, slugs in INSTANCE_GROUPS:
        group_instances = [(s, parsed[s]) for s in slugs if s in parsed]
        if not group_instances:
            continue
        lines.append(f"### {group_name}\n")
        for slug, p in group_instances:
            display, desc = INSTANCE_META.get(slug, (slug, ""))
            lines.append(f"**{display}** - {desc}\n")
            lines.append(header_row)
            lines.append(sep_row)
            for size in all_sizes:
                row = p["data"].get(size)
                if not row:
                    continue
                lines.append(
                    "| {:>5} | {:>17} | {:>17} | {:>11} | {:>11} |".format(
                        size,
                        fmt_num(row["pub_rate"]),
                        fmt_num(row["con_rate"]),
                        fmt_float(row["pub_bw"]),
                        fmt_float(row["con_bw"]),
                    )
                )
            lines.append("")

    return "\n".join(lines)


# ---------------------------------------------------------------------------
# MQTT Throughput summary builder
# ---------------------------------------------------------------------------

def build_mqtt_throughput_summary(parsed: dict, version: str) -> str:
    all_sizes: list[int] = sorted({
        s for p in parsed.values() for s in p["data"]
    })

    lines = []
    lines.append("# LavinMQ MQTT Throughput Results\n")
    lines.append("## Benchmark Setup\n")
    lines.append(
        "- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)\n"
        "- Benchmark-broker (AWS instance, public IP)\n"
        "- Benchmark-loadgen (AWS instance, public IP)\n"
        "\nLoad generator -> MQTT-URL (broker private IP) -> Broker\n"
    )
    lines.append("## Table Headers\n")
    lines.append(
        "- **Size**: Message size in bytes\n"
        "- **Avg. Publish Rate**: Average publish rate in msgs/s\n"
        "- **Avg. Consume Rate**: Average consume rate in msgs/s\n"
        "- **Publish BW**: Publish bandwidth in MiB/s\n"
        "- **Consume BW**: Consume bandwidth in MiB/s\n"
    )
    lines.append("## AWS Instance Types\n")
    duration = next(iter(parsed.values()), {}).get("duration", "60")
    lines.append(f"Benchmark results for AWS instance types with LavinMQ version v{version}.\n")
    lines.append("```shell")
    lines.append(f"mqtt_bench.sh throughput -z {duration} -x 1 -y 1 -s <size>")
    lines.append("```\n")

    header_row = "| {:>5} | {:>17} | {:>17} | {:>11} | {:>11} |".format(
        "Size", "Avg. Publish Rate", "Avg. Consume Rate", "Publish BW", "Consume BW"
    )
    sep_row = "|------:|------------------:|------------------:|------------:|------------:|"

    for group_name, slugs in INSTANCE_GROUPS:
        group_instances = [(s, parsed[s]) for s in slugs if s in parsed]
        if not group_instances:
            continue
        lines.append(f"### {group_name}\n")
        for slug, p in group_instances:
            display, desc = INSTANCE_META.get(slug, (slug, ""))
            lines.append(f"**{display}** - {desc}\n")
            lines.append(header_row)
            lines.append(sep_row)
            for size in all_sizes:
                row = p["data"].get(size)
                if not row:
                    continue
                lines.append(
                    "| {:>5} | {:>17} | {:>17} | {:>11} | {:>11} |".format(
                        size,
                        fmt_num(row["pub_rate"]),
                        fmt_num(row["con_rate"]),
                        fmt_float(row["pub_bw"]),
                        fmt_float(row["con_bw"]),
                    )
                )
            lines.append("")

    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(description="Aggregate LavinMQ benchmark results.")
    parser.add_argument("--version",              required=True,  help="LavinMQ version, e.g. 2.7.0-rc.3")
    parser.add_argument("--latency-dir",          default=None,   help="Directory containing per-instance *_latency.csv files (with matching *_latency.json)")
    parser.add_argument("--throughput-dir",       default=None,   help="Directory containing per-instance *_throughput.csv files (with matching *_throughput.json)")
    parser.add_argument("--mqtt-throughput-dir",  default=None,   help="Directory containing per-instance *_mqtt_throughput.csv files (with matching *_mqtt_throughput.json)")
    parser.add_argument("--output-dir",           required=True,  help="Root results directory (e.g. results/)")
    args = parser.parse_args()

    version = args.version.lstrip("v")
    out_root = Path(args.output_dir) / f"v{version}"

    # ---- Latency -----------------------------------------------------------
    if args.latency_dir and Path(args.latency_dir).is_dir():
        latency_dir = Path(args.latency_dir)
        latency_files = sorted(latency_dir.glob("**/*_latency.csv"))
        if latency_files:
            out_latency = out_root / "latency"
            out_latency.mkdir(parents=True, exist_ok=True)

            parsed_latency: dict = {}
            for f in latency_files:
                slug = slug_from_filename(f, "_latency")
                print(f"  Parsing latency: {f.name} -> slug={slug}")
                # Copy raw files
                shutil.copy2(f, out_latency / f"{slug}_latency.csv")
                json_src = f.with_suffix(".json")
                if json_src.exists():
                    shutil.copy2(json_src, out_latency / f"{slug}_latency.json")
                # Parse
                try:
                    parsed_latency[slug] = parse_latency_files(f, json_src)
                except Exception as e:
                    print(f"  WARNING: failed to parse {f}: {e}")

            for existing_f in sorted(out_latency.glob("*_latency.csv")):
                slug = slug_from_filename(existing_f, "_latency")
                if slug not in parsed_latency:
                    print(f"  Including existing: {existing_f.name} -> slug={slug}")
                    try:
                        parsed_latency[slug] = parse_latency_files(existing_f, existing_f.with_suffix(".json"))
                    except Exception as e:
                        print(f"  WARNING: failed to parse existing {existing_f}: {e}")

            if parsed_latency:
                for pct, label in [("p95", "P95"), ("p99", "P99")]:
                    summary = build_latency_summary(parsed_latency, version, pct, label)
                    out_path = out_root / f"latency_{label}.md"
                    out_path.write_text(summary)
                    print(f"  Written: {out_path}")

        else:
            print(f"  No latency files found in {latency_dir}")

    # ---- Throughput --------------------------------------------------------
    if args.throughput_dir and Path(args.throughput_dir).is_dir():
        throughput_dir = Path(args.throughput_dir)
        throughput_files = sorted(throughput_dir.glob("**/*_throughput.csv"))
        if throughput_files:
            out_throughput = out_root / "throughput"
            out_throughput.mkdir(parents=True, exist_ok=True)

            parsed_throughput: dict = {}
            for f in throughput_files:
                slug = slug_from_filename(f, "_throughput")
                print(f"  Parsing throughput: {f.name} -> slug={slug}")
                shutil.copy2(f, out_throughput / f"{slug}_throughput.csv")
                json_src = f.with_suffix(".json")
                if json_src.exists():
                    shutil.copy2(json_src, out_throughput / f"{slug}_throughput.json")
                try:
                    parsed_throughput[slug] = parse_throughput_files(f, json_src)
                except Exception as e:
                    print(f"  WARNING: failed to parse {f}: {e}")

            for existing_f in sorted(out_throughput.glob("*_throughput.csv")):
                slug = slug_from_filename(existing_f, "_throughput")
                if slug not in parsed_throughput:
                    print(f"  Including existing: {existing_f.name} -> slug={slug}")
                    try:
                        parsed_throughput[slug] = parse_throughput_files(existing_f, existing_f.with_suffix(".json"))
                    except Exception as e:
                        print(f"  WARNING: failed to parse existing {existing_f}: {e}")

            if parsed_throughput:
                summary = build_throughput_summary(parsed_throughput, version)
                out_path = out_root / "throughput.md"
                out_path.write_text(summary)
                print(f"  Written: {out_path}")
        else:
            print(f"  No throughput files found in {throughput_dir}")

    # ---- MQTT Throughput ---------------------------------------------------
    if args.mqtt_throughput_dir and Path(args.mqtt_throughput_dir).is_dir():
        mqtt_throughput_dir = Path(args.mqtt_throughput_dir)
        mqtt_throughput_files = sorted(mqtt_throughput_dir.glob("**/*_mqtt_throughput.csv"))
        if mqtt_throughput_files:
            out_mqtt_throughput = out_root / "mqtt_throughput"
            out_mqtt_throughput.mkdir(parents=True, exist_ok=True)

            parsed_mqtt_throughput: dict = {}
            for f in mqtt_throughput_files:
                slug = slug_from_filename(f, "_mqtt_throughput")
                print(f"  Parsing MQTT throughput: {f.name} -> slug={slug}")
                shutil.copy2(f, out_mqtt_throughput / f"{slug}_mqtt_throughput.csv")
                json_src = f.with_suffix(".json")
                if json_src.exists():
                    shutil.copy2(json_src, out_mqtt_throughput / f"{slug}_mqtt_throughput.json")
                try:
                    parsed_mqtt_throughput[slug] = parse_throughput_files(f, json_src)
                except Exception as e:
                    print(f"  WARNING: failed to parse {f}: {e}")

            for existing_f in sorted(out_mqtt_throughput.glob("*_mqtt_throughput.csv")):
                slug = slug_from_filename(existing_f, "_mqtt_throughput")
                if slug not in parsed_mqtt_throughput:
                    print(f"  Including existing: {existing_f.name} -> slug={slug}")
                    try:
                        parsed_mqtt_throughput[slug] = parse_throughput_files(existing_f, existing_f.with_suffix(".json"))
                    except Exception as e:
                        print(f"  WARNING: failed to parse existing {existing_f}: {e}")

            if parsed_mqtt_throughput:
                summary = build_mqtt_throughput_summary(parsed_mqtt_throughput, version)
                out_path = out_root / "mqtt_throughput.md"
                out_path.write_text(summary)
                print(f"  Written: {out_path}")
        else:
            print(f"  No MQTT throughput files found in {mqtt_throughput_dir}")

    print("Aggregation complete.")


if __name__ == "__main__":
    main()
