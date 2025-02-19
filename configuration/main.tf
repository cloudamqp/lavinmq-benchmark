terraform {
  required_providers {
    cloudamqp = {
      source = "cloudamqp/cloudamqp"
    }
  }
}

# Standalone VPC shared between the instances
resource "cloudamqp_vpc" "vpc" {
  name    = "lavinmq-benchmark"
  subnet  = "10.56.72.0/24"
  region  = local.region
  tags    = local.tags
}

# Instance being benchmarked
resource "cloudamqp_instance" "instance" {
  name                = "lavinmq-benchmark-${random_string.this.result}"
  plan                = local.benchmark_instance_plan
  region              = local.region
  tags                = local.tags
  rmq_version         = local.benchmark_instance_version
  vpc_id	            = cloudamqp_vpc.vpc.id
  keep_associated_vpc = true
}

data "cloudamqp_nodes" "perftest-nodes" {
  instance_id = cloudamqp_instance.instance.id
}

# Instance running perftest
resource "cloudamqp_instance" "perftest" {
  name                = "lavinmqperftest"
  plan                = local.perftest_instance_plan
  region              = local.region
  tags                = local.tags
  vpc_id	            = cloudamqp_vpc.vpc.id
  keep_associated_vpc = true
}