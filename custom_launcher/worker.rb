#!/usr/bin/env ruby

require_relative "util"
require_relative "pull_activity"
require_relative "convert_activity"
require_relative "push_activity"

class Worker
  extend AWS::Flow::Workflows

  workflow :execute_sample_workflow do
    {
      :version => "0.57",
      :task_list => Util.instance.workflow_task_list,
      :default_task_start_to_close_timeout => 15,
      :default_task_schedule_to_start_timeout => 10,
      :execution_start_to_close_timeout => 20
    }
  end

  activity_client(:pull_client) { {:from_class => "PullActivity"} }
  activity_client(:convertl_client) { {:from_class => "ConvertActivity"} }
  activity_client(:push_client) { {:from_class => "PushActivity"} }

  def execute_sample_workflow(params)
    puts "Executing workflow... (params=#{params})"
    begin
      error_handler do |t|
        t.begin do
          puts "Pull"
          o1 = pull_client.send_async(:pull)
          
          puts "Convert"
          o2 = convertl_client.send_async(:convert_a)
          o3 = convertl_client.send_async(:convert_b)
          
          wait_for_all o1, o2, o3

          puts "Convert all"
          o4 = convertl_client.send_async(:convert_c, { test: "a" * 40000 })
          wait_for_all o4
          
          puts "Push"
          o5 = push_client.send_async(:push)
          wait_for_all o5

          puts "Completed"
    
        end
        t.rescue Exception do |e|
          puts "Failed to pull"
          puts e
          puts e.backtrace.join("\n")
        end
        t.ensure do
          puts "Ensure"
        end
      end
    rescue => e
      puts "Failed to execute activity"
      puts e
      puts e.backtrace.join("\n")
    end
  end
end

begin
  worker = AWS::Flow::WorkflowWorker.new(Util.instance.swf.client, Util.instance.domain, Util.instance.workflow_task_list, Worker)
  worker.start if __FILE__ == $0
rescue Exception => e
  puts "Failed to execute worker"
  puts e
  puts e.backtrace.join("\n")
end
