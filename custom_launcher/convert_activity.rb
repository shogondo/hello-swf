#!/usr/bin/env ruby

require_relative "util"

class ConvertActivity
  extend AWS::Flow::Activities

  activity :convert_a, :convert_b, :convert_c do
    {
      :default_task_list => Util.instance.convert_activity_task_list,
      :version => "0.28",
      :default_task_schedule_to_start_timeout => 180,
      :default_task_start_to_close_timeout => 180
    }
  end

  def convert_a
    puts "#{Time.now} Converted a"
  end
  
  def convert_b
    puts "#{Time.now} Converted b"
  end
      
  def convert_c(params)
    puts "#{Time.now} Converted c (#{params})."
  end
end

activity_worker = AWS::Flow::ActivityWorker.new(Util.instance.swf.client, Util.instance.domain, Util.instance.convert_activity_task_list, ConvertActivity) { { :use_forking => false } }

activity_worker.start if __FILE__ == $0
