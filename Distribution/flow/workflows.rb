require 'flow/activities'

# BookingWorkflow class defines the workflows for the Booking sample
class DistributionWorkflow
  extend AWS::Flow::Workflows

  # Use the workflow method to define workflow entry point.
  workflow :distribute_flow do
    {
      version: "1.0",
      default_execution_start_to_close_timeout: 120
    }
  end

  # Create an activity client using the activity_client method to schedule
  # activities
  activity_client(:accept_client) { { from_class: "AcceptActivity" } }
  activity_client(:process_client) { { from_class: "ProcessActivity" } }
  activity_client(:distribution_client) { { from_class: "DistributionActivity" } }

  # This is the entry point for the workflow
  def distribute_flow options
    request_id = options[:request_id]

    puts "Distribution workflow has started #{request_id}\n"
    futures = []

    begin
      accept_client.accept1(request_id)
      accept_client.accept2(request_id)
      puts accept_client.accept3(request_id)

      futures << process_client.send_async(:process1, request_id)
      futures << process_client.send_async(:process2, request_id)
      wait_for_all(futures)
      result = futures[0].get
      puts result

      if result[:result] == 0
        distribution_client.distribute1(request_id)
      else
        distribution_client.distribute2(request_id)
      end
    rescue => e
      puts "Error #{e}"
    end

    puts "Workflow has completed\n"
  end
end


module AWS
  module Flow
    module Utilities
      class LogFactory
        def self.make_logger_with_level(klass, level)
          puts "Overwrite logger"
          logname = "/Users/shoutak/tmp/swf-logs/#{klass.class.to_s}"
          logname.gsub!(/::/, '-')
          log = Logger.new(logname)
          log.level = level
          log
        end
      end
    end
  end
end
