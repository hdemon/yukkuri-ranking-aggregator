#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/ruby/bin:/home/app/.rbenv/bin:/home/app/.rbenv/shims:/home/app/.rbenv/plugins

cd /home/app
git clone https://github.com/hdemon/yukkuri-ranking-aggregator.git
cd /home/app/yukkuri-ranking-aggregator
rbenv exec bundle --path vendor/bundle -j4
rbenv exec bundle exec rake db:create
rbenv exec bundle exec rake db:migrate

echo "10 17 * * * /bin/bash -l -c 'cd /home/app/yukkuri-ranking-aggregator && bundle exec rake crawl:daily >> /var/log/cron_log.log 2>&1'" >> /var/spool/cron/crontabs/app
cron -f
