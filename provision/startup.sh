#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/ruby/bin:/home/app/.rbenv/bin:/home/app/.rbenv/shims:/home/app/.rbenv/plugins

cd /home/app/yukkuri-ranking-aggregator
rbenv exec bundle exec rake db:create
rbenv exec bundle exec rake db:migrate

cron -f
