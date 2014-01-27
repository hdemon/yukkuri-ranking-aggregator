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
  db: YAML.load_file("./config/database.yml")[ENV["NICO_CRAWLER_ENV"]],
  crawler: YAML.load_file("./config/crawler.yml")[ENV["NICO_CRAWLER_ENV"]]
}


namespace :db do
  task :migrate => [:set_db_logger, :connect_db] do
    ActiveRecord::Base.establish_connection config[:db]
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

  task :create => :set_db_logger do
    # DB作成前なので、establish_connectionにdatabaseというキーのあるハッシュを渡すとエラーになる。
    ActiveRecord::Base.establish_connection config[:db].dup.tap {|s| s.delete "database" }
    ActiveRecord::Base.connection.create_database config[:db]["database"]
  end
end

namespace :crawl do
  task :daily => :connect_db do
    Crawler.get_latest_part1_movie_from_web
    Crawler.retrieve_series_mylists
    Crawler.get_series_mylists
    Crawler.get_mutable_movie_info_of_all_mylists
<<<<<<< HEAD
=======
  end
end

namespace :aggregate do
  task :daily_rankings => :connect_db do
    Aggregator.refresh_daily_rankings
>>>>>>> fix
  end
end

task :connect_db do
  ActiveRecord::Base.establish_connection config[:db]
end

task :set_db_logger do
  ActiveRecord::Base.logger = Logger.new(File.open('db/database.log', 'a'))
end
