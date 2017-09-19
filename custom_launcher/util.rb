require 'aws/decider'
require 'yaml'
require 'singleton'

class Util
  include Singleton

  def initialize
    config_file = File.open('config.yml') { |f| f.read }
    config = YAML.load(config_file)
    AWS.config(config)
  end

  def swf
    @swf ||= AWS::SimpleWorkflow.new
  end

  def domain
    @domain ||= swf.domains["custom-launcher"]
  end

  def workflow_task_list
    "custom_launcher_workflow_task_list"
  end

  def pull_activity_task_list
    "custom_launcher_pull_activity_task_list"
  end

  def convert_activity_task_list
    "custom_launcher_convert_activity_task_list"
  end

  def push_activity_task_list
    "custom_launcher_push_activity_task_list"
  end
end
