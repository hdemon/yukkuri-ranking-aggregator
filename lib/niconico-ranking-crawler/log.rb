require 'logger'


# see http://twei55.github.io/blog/2012/01/26/ruby-singleton-logger/
class Log < Logger
  LOG_FILE = File.open("log/crawler.log", "a")

  def self.logger
    @@log ||= Logger.new(LOG_FILE, :daily)
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
end
