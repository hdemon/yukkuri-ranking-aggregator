require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'active_record'
require 'yaml'
require 'logger'
require 'niconico-ranking-crawler'

spec = eval(File.read('niconico-ranking-crawler.gemspec'))
ENV["NICO_CRAWLER_ENV"] ||= 'local'


config = {
  adapter: "mysql2",
  encoding: "utf8",
  database: ENV["NC_DB_USERNAME"] || "yukkuri",
  pool: 5,
  username: ENV["NC_DB_USERNAME"] || "root",
  password: ENV["NC_DB_PASS"] || "",
  socket: ENV["NC_DB_SOCKET_PATH"] || "/tmp/mysql.sock"
}

ENV["NC_LOG_PATH"] = "./tmp/crawler.log"
ENV["NC_PART_ONE_TAG"] = "ゆっくり実況プレイpart1リンク or VOICEROID実況プレイPart1リンク"


namespace :db do
  task :migrate => [:set_db_logger, :connect_db] do
    ActiveRecord::Base.establish_connection config
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

  task :create => :set_db_logger do
    # DB作成前なので、establish_connectionにdatabaseというキーのあるハッシュを渡すとエラーになる。
    ActiveRecord::Base.establish_connection config.dup.tap {|s| s.delete "database" }
    ActiveRecord::Base.connection.create_database config["database"]
  end
end

namespace :crawl do
  desc "Run daily crawl task"
  task :daily => :connect_db do
    Crawler.get_latest_part1_movie_from_web
    Crawler.retrieve_series_mylists
    Crawler.get_series_mylists
    Crawler.get_mutable_movie_info_of_all_mylists
  end
end

namespace :aggregate do
  task :daily_rankings => :connect_db do
    Aggregator.refresh_daily_rankings
  end
end

namespace :deploy do
  task :web_app do
    config = YAML.load_file("./config/deploy.yml")[ENV["target"]]
    sh "fab deploy -H #{config["host"]} -i #{config["ssh_private_key"]} -u #{config["username"]} --fabfile ./provision/fabfile/"
  end
end

task :connect_db do
  ActiveRecord::Base.establish_connection config
end

task :set_db_logger do
  ActiveRecord::Base.logger = Logger.new(File.open('db/database.log', 'a'))
end
