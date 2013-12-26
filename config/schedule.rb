# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "~/cron_log.log"

# utc
every 1.day, at: '17:13 am' do
  command "cd /home/yukkuri/yukkuri-crawler/releases/current && RAILS_ENV=production bundle exec rake daily ENV=production >> ~/cron_log.log 2>&1"
end