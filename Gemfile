source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0.rc1'
gem "mysql2"
gem "unicorn"
gem "nicoquery"

group :doc do
end

group :test do
  gem "rspec"
  gem "webmock"
  gem "database_cleaner"
  gem "factory_girl"
  gem "ffaker"
  gem "simplecov", require: false
  gem "simplecov-rcov", require: false
end

group :development do
  gem "better_errors"
  gem "rspec-rails"
  gem "rails-erd"
  gem "binding_of_caller"
  gem "quiet_assets"
  gem "awesome_print"
end

group :test, :development do
  gem "pry"
  gem "pry-rails"
  gem 'guard-rspec'
  gem 'spring'
  gem 'guard-spring'
end

gem "whenever"
