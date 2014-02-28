# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','yukkuri-ranking-aggregator','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'yukkuri-ranking-aggregator'
  s.version = NiconicoRankingCrawler::VERSION
  s.author = 'Masami Yonehara(hdemon)'
  s.email = 'zeitdiebe@gmail.com'
  s.homepage = 'http://hdemon.net'
  s.platform = Gem::Platform::RUBY
  s.summary = 'The data aggregator of Yukkuri Ranking'
# Add your other files here if you make them
  s.files = %w(
lib/yukkuri-ranking-aggregator/version.rb
lib/yukkuri-ranking-aggregator.rb
  )
  s.require_paths << 'lib'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'pry'

  s.add_runtime_dependency 'nicoquery'
  s.add_runtime_dependency 'mysql2'
  s.add_runtime_dependency 'activerecord', '~>4.0.0'
  s.add_runtime_dependency 'configatron', '3.0.0.rc1'
  s.add_runtime_dependency 'whenever'
  s.add_runtime_dependency 'pry'
end