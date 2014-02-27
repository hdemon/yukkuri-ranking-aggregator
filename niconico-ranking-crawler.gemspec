# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','niconico-ranking-crawler','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'niconico-ranking-crawler'
  s.version = NiconicoRankingCrawler::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
# Add your other files here if you make them
  s.files = %w(
bin/niconico-ranking-crawler
lib/niconico-ranking-crawler/version.rb
lib/niconico-ranking-crawler.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','niconico-ranking-crawler.rdoc']
  s.rdoc_options << '--title' << 'niconico-ranking-crawler' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'niconico-ranking-crawler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'whenever'
  s.add_development_dependency 'pry'

  s.add_runtime_dependency 'nicoquery'
  s.add_runtime_dependency 'mysql2'
  s.add_runtime_dependency 'activerecord', '~>4.0.0'
  s.add_runtime_dependency 'configatron', '3.0.0.rc1'
  s.add_runtime_dependency 'whenever'
  s.add_runtime_dependency 'pry'
end
