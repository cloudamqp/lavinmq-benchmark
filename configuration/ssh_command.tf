# Creates the perftest SSH command
resource "terraform_data" "perftest_command" {
  input = format("ssh %s '%s --uri=%s'",
    data.cloudamqp_nodes.perftest-nodes.nodes[0].hostname,
    local.perftest,
    cloudamqp_instance.instance.url)

  depends_on = [
    cloudamqp_instance.perftest
  ]
}