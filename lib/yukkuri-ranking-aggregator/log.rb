require 'logger'

# see http://twei55.github.io/blog/2012/01/26/ruby-singleton-logger/
class Log
  CONFIG = YAML.load_file("./config/config.yml")

  include Singleton
  attr_reader :logger

  def initialize
    @logger = Logger.new log_file, 'daily'
  end

  def self.logger
    return Log.instance.logger
  end

  def log_file
    File.open(CONFIG["log_file_path"], "a")
  end
end
