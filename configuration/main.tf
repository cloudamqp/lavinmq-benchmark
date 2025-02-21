terraform {
  required_providers {
    cloudamqp = {
      source = "cloudamqp/cloudamqp"
    }
  }
}

# Standalone VPC shared between the instances
resource "cloudamqp_vpc" "vpc" {
  name   = "lavinmq-benchmark"
  subnet = "10.56.72.0/24"
  region = local.region
  tags   = local.tags
}

# Instance being benchmarked
resource "cloudamqp_instance" "instance" {
  count = length(local.benchmark_versions)

  name                = "lavinmq-benchmark-${count.index}"
  plan                = local.benchmark_plan
  region              = local.region
  tags                = local.tags
  rmq_version         = local.benchmark_versions[count.index]
  vpc_id              = cloudamqp_vpc.vpc.id
  keep_associated_vpc = true
}

# Instance running perftest
resource "cloudamqp_instance" "perftest" {
  count = length(local.benchmark_versions)

  name                = "lavinmqperftest"
  plan                = local.perftest_plan
  region              = local.region
  tags                = local.tags
  vpc_id              = cloudamqp_vpc.vpc.id
  keep_associated_vpc = true
}

# Perftest nodes
data "cloudamqp_nodes" "perftest-nodes" {
  count = length(cloudamqp_instance.perftest)

  instance_id = cloudamqp_instance.perftest[count.index].id
}
