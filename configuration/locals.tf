# Local variavles to configure instances used to be benchmarked and running perftest
locals {
  benchmark_instance_plan    = "penguin-1"
  benchmark_instance_version = null
  perftest_instance_plan     = "lynx-1"
  region                     = "amazon-web-services::eu-central-1"
  tags                       = ["lavinmq", "benchmark"]
}

# LavinMQ Perf test command. --uri= will be poplated in terraform_data.perftest_command
locals {
  perftest = "lavinmqperf throughput -z 5 -x 1 -y 1 -s 16"
}