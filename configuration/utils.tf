# Create a random string with length 6, used together with randomize 
# cloudamqp_instance.instance names.
resource "random_string" "this" {
  length  = 6
  special = false
}

# Local execute of SSH command starting the LavinMQ perftest on perftest instance. 
resource "terraform_data" "local_exec" {
  triggers_replace = [
    terraform_data.perftest_command.input
  ]

  provisioner "local-exec" {
    command = "${terraform_data.perftest_command.output}"
  }

  depends_on = [
    cloudamqp_instance.instance,
    data.cloudamqp_nodes.perftest-nodes
  ]
}