require 'aws/decider'

input = {
  request_id: ARGV[0] || "x"
}

opts = {
  domain: "Distribution",
  version: "1.0"
}

AWS::Flow::start_workflow("DistributionWorkflow.distribute_flow", input, opts)
