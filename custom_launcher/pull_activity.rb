#!/usr/bin/env ruby

require_relative "util"

class PullActivity
  extend AWS::Flow::Activities

  activity :pull do
    {
      :default_task_list => Util.instance.pull_activity_task_list,
      :version => "0.28",
      :default_task_schedule_to_start_timeout => 180,
      :default_task_start_to_close_timeout => 180
    }
  end

  def pull
    puts "#{Time.now} Pulled."
    "a" * 10
  end
end

activity_worker = AWS::Flow::ActivityWorker.new(Util.instance.swf.client, Util.instance.domain, Util.instance.pull_activity_task_list, PullActivity) { { :use_forking => false } }

activity_worker.start if __FILE__ == $0
