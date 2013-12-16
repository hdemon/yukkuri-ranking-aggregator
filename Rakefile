require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'
require 'cucumber'
require 'cucumber/rake/task'
require 'active_record'
require 'yaml'
require 'logger'
require 'niconico-ranking-crawler'

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
  rd.title = 'Your application title'
end

spec = eval(File.read('niconico-ranking-crawler.gemspec'))
config = YAML.load_file "./config/database.yml"
ENV["env"] ||= 'development'

task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
  ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))[ENV["env"]])
  ActiveRecord::Base.logger = Logger.new(File.open('db/database.log', 'a'))
end

task :create_database => :environment do
  config = YAML::load(File.open('config/database.yml'))[ENV["env"]]
  config.delete 'database'
  ActiveRecord::Base.establish_connection config
  dbname = YAML::load(File.open('config/database.yml'))[ENV["env"]]["database"]
  ActiveRecord::Base.connection.create_database(dbname)
end

task :daily do
  ActiveRecord::Base.establish_connection config[ENV["env"]]
  Crawler.get_latest_part1_movie_from_web
  Crawler.retrieve_series_mylist
  Crawler.get_series_mylist
  Crawler.get_mutable_movie_info_of_all_mylists
end
