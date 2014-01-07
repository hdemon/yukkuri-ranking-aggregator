require 'logger'


# see http://twei55.github.io/blog/2012/01/26/ruby-singleton-logger/
class Log
  include Singleton
  attr_reader :logger

  def initialize
    @logger = Logger.new log_file, 'daily'
  end

  def self.logger
    return Log.instance.logger
  end

  def log_file
    env = test_env? ? "test" : specified_env
    File.open(YAML.load_file("config/crawler.yml")["log_file_path"][env], "a")
  end

  def test_env?
    $test_env == true
  end

  def specified_env
    ENV["NICO_CRAWLER_ENV"].presence || "local"
  end
end
