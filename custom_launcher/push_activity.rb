#!/usr/bin/env ruby

require_relative "util"

class PushActivity
  extend AWS::Flow::Activities

  activity :push do
    {
      :default_task_list => Util.instance.push_activity_task_list,
      :version => "0.28",
      :default_task_schedule_to_start_timeout => 180,
      :default_task_start_to_close_timeout => 180
    }
  end

  def push
    puts "#{Time.now} Pushed."
  end
end

activity_worker = AWS::Flow::ActivityWorker.new(Util.instance.swf.client, Util.instance.domain, Util.instance.push_activity_task_list, PushActivity) { { :use_forking => false } }

activity_worker.start if __FILE__ == $0
