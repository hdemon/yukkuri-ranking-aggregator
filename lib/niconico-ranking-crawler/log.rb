require 'logger'


# see http://twei55.github.io/blog/2012/01/26/ruby-singleton-logger/
class Log < Logger
  include Singleton
  LOG_FILE = File.open("/var/log/crawler.log", "a")

  def initialize
    @logdev = Logger::LogDevice.new(LOG_FILE, :daily)
    @level = INFO
  end

  def set_log_level
    @@log.level = case level
    when :fatal then Logger::FATAL
    when :error then Logger::ERROR
    when :warn then Logger::WARN
    when :info then Logger::INFO
    when :debug then Logger::DEBUG
    else :warn
    end
  end

  def self.logger
    return Log.instance
  end
end
