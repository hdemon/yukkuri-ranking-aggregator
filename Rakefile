require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'active_record'
require 'yaml'
require 'logger'
require 'yukkuri-ranking-aggregator'
config = YAML.load_file("./config/config.yml")

namespace :db do
  task :migrate => [:set_db_logger, :connect_db] do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

  task :create => :set_db_logger do
    # DB作成前なので、establish_connectionにdatabaseというキーのあるハッシュを渡すとエラーになる。
    ActiveRecord::Base.establish_connection config["database"].dup.tap {|s| s.delete "database" }
    ActiveRecord::Base.connection.create_database config["database"]["database"]
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

task :connect_db do
  ActiveRecord::Base.establish_connection config["database"]
end

task :set_db_logger do
  ActiveRecord::Base.logger = Logger.new(File.open('db/database.log', 'a'))
end
