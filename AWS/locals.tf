locals {
  benchmark = {
    instance_type = "t4g.small"
    name          = "Benchmark"
  }

  perftest = {
    instance_type = "t4g.small"
    name          = "Performance tester"
    command       = "lavinmqperf throughput -z 10 -x 1 -y 1 -s 16"
  }

  created_by = "tobias@tobias-XPS-9315"
  name       = "tobias-test"
}

locals {
  bootstrap = <<-EOL
  #!/bin/bash -xe

  apt update
  curl -fsSL https://packagecloud.io/84codes/crystal/gpgkey | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/84codes_crystal.gpg > /dev/null
  . /etc/os-release
  echo "deb https://packagecloud.io/84codes/crystal/$ID $VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/84codes_crystal.list
  apt update
  apt install crystal -y

  curl -fsSL https://packagecloud.io/cloudamqp/lavinmq/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/lavinmq.gpg > /dev/null
  . /etc/os-release
  echo "deb [signed-by=/usr/share/keyrings/lavinmq.gpg] https://packagecloud.io/cloudamqp/lavinmq/$ID $VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/lavinmq.list
  apt update
  apt install lavinmq -y

  lavinmqctl add_user perftest perftest
  lavinmqctl set_user_tags perftest administrator
  lavinmqctl set_permissions perftest .* .* .*
  EOL
}