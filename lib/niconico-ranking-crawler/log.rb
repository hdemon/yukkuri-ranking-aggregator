require 'logger'


# see http://twei55.github.io/blog/2012/01/26/ruby-singleton-logger/
class Log
  include Singleton
  attr_reader :logger

  LOG_FILE = File.open(YAML.load_file("config/crawler.yml")["log_file_path"], "a")

  def initialize
    @logger = Logger.new LOG_FILE, 'daily'
  end

  def self.logger
    return Log.instance.logger
  end
end
