#!/usr/bin/env ruby

require "aws/decider"
require_relative "util"
require_relative "worker"
include AWS::Flow

begin
  puts "Start workflow execution."
  client = workflow_client(Util.instance.swf.client, Util.instance.domain) { { :from_class => "Worker" } }
  workflow_execution = client.start_execution({ foo: "bar" })
rescue Exception => e
  puts "Failed to launch workflow execution."
  puts e
  puts e.backtrace.join("\n")  
end
