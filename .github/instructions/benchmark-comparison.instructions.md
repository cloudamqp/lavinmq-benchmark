---
description: "Use when comparing LavinMQ benchmark result summaries across releases or preparing benchmark PR comments."
applyTo: "results/**/*.md"
---

# Benchmark Comparisons

When comparing a new LavinMQ benchmark release:

1. Verify completeness before comparing:
   - Confirm all four summaries exist:
     - `latency_P95.md`
     - `latency_P99.md`
     - `throughput.md`
     - `mqtt_throughput.md`
   - Confirm expected instance sections and raw CSV/JSON files exist.
   - Identify missing, zero-result, parse-error, or incomplete runs.
   - Do not treat invalid or incomplete values as performance results.

2. Compare versions chronologically:
   - Present columns from oldest to newest.
   - Include all requested releases, for example:
     `v2.9.0`, `v2.9.1`, `v2.9.2`, `v2.9.3`, `v2.10.0-rc.1`.
   - Use the newest release as the subject of the comparison.
   - Compare P95 and P99 latency separately.
   - Compare AMQP throughput and MQTT throughput separately.

3. Use focused comparison tables:
   - Include representative high-load cases.
   - Include clear regressions and improvements.
   - For latency, lower values are better.
   - For throughput, higher values are better.
   - Report absolute values and meaningful percentage or multiplier changes.
   - Highlight anomalies, failed runs, zero consume rates, and parser/aggregation concerns.

4. Account for environment differences:
   - Mention AMI, kernel, instance, benchmark duration, or configuration changes that may affect comparability.
   - Treat separately rerun instances as valid data but flag them when the environment differs from the main run.
   - Do not claim a LavinMQ regression when the evidence may be explained by infrastructure or test conditions.

5. End with an `Overall Assessment` section:
   - Summarize result completeness.
   - Summarize P95 latency.
   - Summarize P99 latency.
   - Summarize AMQP throughput.
   - Summarize MQTT throughput.
   - List the strongest improvements.
   - List the most important regressions or invalid results.
   - State whether the release looks ready based on the benchmark evidence.
   - Keep this section suitable for manually adding to the benchmark results PR as a commit or PR comment.

The comparison output should be concise, evidence-based, and organized for potential inclusion in a GitHub PR description or comment.