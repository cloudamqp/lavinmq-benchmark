# Local variavles to configure instances used to be benchmarked and running perftest
locals {
  benchmark_plan     = "penguin-1"
  benchmark_versions = tolist([null])
  perftest_plan      = "lynx-1"
  region             = "azure-arm::northeurope"
  tags               = ["lavinmq", "benchmark"]
}

# LavinMQ Perf test command. --uri= will be poplated in terraform_data.perftest_command
locals {
  perftest = "lavinmqperf throughput -z 120 -x 1 -y 1 -s 16"
}