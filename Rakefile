require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'active_record'
require 'yaml'
require 'logger'
require 'niconico-ranking-crawler'


ENV["NC_PART_ONE_TAG"] = "ゆっくり実況プレイpart1リンク or VOICEROID実況プレイPart1リンク"
config = YAML.load_file("./config/config.yml")


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

task :build_basement do
  sh "fab build_basement -H #{config["host"]} -i #{config["ssh_private_key"]} -u #{config["username"]} --fabfile ./provision/fabfile/"
end

task :deploy do
  sh "fab deploy -H #{config["host"]} -i #{config["ssh_private_key"]} -u #{config["username"]} --fabfile ./provision/fabfile/"
end

task :install_docker do
  config = YAML.load_file("./config/deploy.yml")[ENV["target"]]
  sh "fab install_docker -H #{config["host"]} -i #{config["ssh_private_key"]} -u #{config["username"]} --fabfile ./provision/fabfile/"
end

task :connect_db do
  ActiveRecord::Base.establish_connection config
end

task :set_db_logger do
  ActiveRecord::Base.logger = Logger.new(File.open('db/database.log', 'a'))
end
