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
import os
import re
import shutil
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

def parse_latency_file(path: Path) -> dict:
    """
    Parse a per-instance latency_results.md produced by run_multiple_latency_tests.sh.

    Returns:
        {
          "instance_type": str,          # from '# t4g.micro' header
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
    text = path.read_text()
    result = {
        "instance_type": "",
        "lavinmq_version": "",
        "duration": "",
        "sizes": [],
        "data": {},
    }

    # Instance type from first heading
    m = re.search(r"^#\s+(.+)$", text, re.MULTILINE)
    if m:
        result["instance_type"] = m.group(1).strip()

    # Duration
    m = re.search(r"Duration:\s*(\d+)\s*seconds", text)
    if m:
        result["duration"] = m.group(1)

    # Find each "## Message Size: N bytes" section
    # Use the Summary table when present (multi-run), otherwise the single table.
    size_sections = re.split(r"^## Message Size:\s*(\d+)\s*bytes", text, flags=re.MULTILINE)
    # size_sections[0] = preamble, then pairs of (size_str, section_text)
    i = 1
    while i < len(size_sections) - 1:
        size = int(size_sections[i])
        section = size_sections[i + 1]
        i += 2

        result["sizes"].append(size)
        result["data"][size] = {}

        # Prefer "### Summary" block when num_runs > 1
        summary_match = re.search(r"### Summary[^\n]*\n(.*?)(?=^###|\Z)", section,
                                  re.DOTALL | re.MULTILINE)
        table_text = summary_match.group(1) if summary_match else section

        # Parse markdown table rows (skip header and separator)
        for row in re.finditer(
            r"^\|\s*([\d,]+)\s*\|"   # rate
            r"\s*([\d.]+)\s*\|"       # min
            r"\s*([\d.]+)\s*\|"       # median
            r"\s*([\d.]+)\s*\|"       # p75
            r"\s*([\d.]+)\s*\|"       # p95
            r"\s*([\d.]+)\s*\|"       # p99
            r"\s*([\d,]+)\s*\|"       # pub_rate
            r"\s*([\d.]+)\s*\|"       # pub_bw
            r"\s*([\d.]+)\s*\|",      # con_bw
            table_text,
            re.MULTILINE,
        ):
            rate = int(row.group(1).replace(",", ""))
            result["data"][size][rate] = {
                "min":      row.group(2),
                "median":   row.group(3),
                "p75":      row.group(4),
                "p95":      row.group(5),
                "p99":      row.group(6),
                "pub_rate": row.group(7).replace(",", ""),
                "pub_bw":   row.group(8),
                "con_bw":   row.group(9),
            }

    return result


# ---------------------------------------------------------------------------
# Throughput parsing
# ---------------------------------------------------------------------------

def parse_throughput_file(path: Path) -> dict:
    """
    Parse a per-instance throughput_results.md produced by run_multiple_throughput_tests.sh.

    Returns:
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
    text = path.read_text()
    result = {
        "instance_type": "",
        "lavinmq_version": "",
        "duration": "",
        "data": {},
    }

    m = re.search(r"Broker Instance Type:\s*(.+)$", text, re.MULTILINE)
    if m:
        result["instance_type"] = m.group(1).strip()

    m = re.search(r"LavinMQ Version:\s*(.+)$", text, re.MULTILINE)
    if m:
        result["lavinmq_version"] = m.group(1).strip()

    m = re.search(r"Duration:\s*(\d+)\s*seconds", text)
    if m:
        result["duration"] = m.group(1)

    # Prefer "### Summary" table when present
    summary_match = re.search(r"### Summary[^\n]*\n(.*?)(?=^###|^##|\Z)", text,
                               re.DOTALL | re.MULTILINE)
    table_text = summary_match.group(1) if summary_match else text

    for row in re.finditer(
        r"^\|\s*(\d+)\s*\|"          # size
        r"\s*([\d,]+)\s*\|"          # pub_rate
        r"\s*([\d,]+)\s*\|"          # con_rate
        r"\s*([\d.]+)\s*\|"          # pub_bw
        r"\s*([\d.]+)\s*\|",         # con_bw
        table_text,
        re.MULTILINE,
    ):
        size = int(row.group(1))
        result["data"][size] = {
            "pub_rate": row.group(2).replace(",", ""),
            "con_rate": row.group(3).replace(",", ""),
            "pub_bw":   row.group(4),
            "con_bw":   row.group(5),
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
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(description="Aggregate LavinMQ benchmark results.")
    parser.add_argument("--version",        required=True,  help="LavinMQ version, e.g. 2.7.0-rc.3")
    parser.add_argument("--latency-dir",    default=None,   help="Directory containing per-instance *_latency.md files")
    parser.add_argument("--throughput-dir", default=None,   help="Directory containing per-instance *_throughput.md files")
    parser.add_argument("--output-dir",     required=True,  help="Root results directory (e.g. results/)")
    args = parser.parse_args()

    version = args.version.lstrip("v")
    out_root = Path(args.output_dir) / f"v{version}"

    # ---- Latency -----------------------------------------------------------
    if args.latency_dir and Path(args.latency_dir).is_dir():
        latency_dir = Path(args.latency_dir)
        latency_files = sorted(latency_dir.glob("**/*_latency.md"))
        if latency_files:
            out_latency = out_root / "latency"
            out_latency.mkdir(parents=True, exist_ok=True)

            parsed_latency: dict = {}
            for f in latency_files:
                slug = slug_from_filename(f, "_latency")
                print(f"  Parsing latency: {f.name} -> slug={slug}")
                # Copy raw file
                dest = out_latency / f"{slug}_latency.md"
                shutil.copy2(f, dest)
                # Parse
                try:
                    parsed_latency[slug] = parse_latency_file(f)
                except Exception as e:
                    print(f"  WARNING: failed to parse {f}: {e}")

            for existing_f in sorted(out_latency.glob("*_latency.md")):
                slug = slug_from_filename(existing_f, "_latency")
                if slug not in parsed_latency:
                    print(f"  Including existing: {existing_f.name} -> slug={slug}")
                    try:
                        parsed_latency[slug] = parse_latency_file(existing_f)
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
        throughput_files = sorted(throughput_dir.glob("**/*_throughput.md"))
        if throughput_files:
            out_throughput = out_root / "throughput"
            out_throughput.mkdir(parents=True, exist_ok=True)

            parsed_throughput: dict = {}
            for f in throughput_files:
                slug = slug_from_filename(f, "_throughput")
                print(f"  Parsing throughput: {f.name} -> slug={slug}")
                dest = out_throughput / f"{slug}_throughput.md"
                shutil.copy2(f, dest)
                try:
                    parsed_throughput[slug] = parse_throughput_file(f)
                except Exception as e:
                    print(f"  WARNING: failed to parse {f}: {e}")

            for existing_f in sorted(out_throughput.glob("*_throughput.md")):
                slug = slug_from_filename(existing_f, "_throughput")
                if slug not in parsed_throughput:
                    print(f"  Including existing: {existing_f.name} -> slug={slug}")
                    try:
                        parsed_throughput[slug] = parse_throughput_file(existing_f)
                    except Exception as e:
                        print(f"  WARNING: failed to parse existing {existing_f}: {e}")

            if parsed_throughput:
                summary = build_throughput_summary(parsed_throughput, version)
                out_path = out_root / "throughput.md"
                out_path.write_text(summary)
                print(f"  Written: {out_path}")
        else:
            print(f"  No throughput files found in {throughput_dir}")

    print("Aggregation complete.")


if __name__ == "__main__":
    main()
