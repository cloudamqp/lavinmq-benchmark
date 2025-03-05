# Creates the perftest SSH command
resource "terraform_data" "perftest_command" {
  count = length(cloudamqp_instance.perftest)

  input = format("ssh %s '%s --uri=%s'",
    data.cloudamqp_nodes.perftest-nodes[count.index].nodes[0].hostname,
    local.perftest_command,
    cloudamqp_instance.instance[count.index].url
  )
}

# # Local execute of SSH command starting the LavinMQ perftest on perftest instance. 
resource "terraform_data" "local_exec" {
  count = length(cloudamqp_instance.perftest)

  triggers_replace = [
    terraform_data.perftest_command[count.index].input
  ]

  provisioner "local-exec" {
    command = terraform_data.perftest_command[count.index].output
  }
}