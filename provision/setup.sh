#!/bin/sh
export PATH=$PATH:/usr/ruby/bin

git clone https://github.com/hdemon/yukkuri-ranking-aggregator.git
cd yukkuri-ranking-aggregator && bundle install -j4

echo "10 17 * * * /bin/bash -l -c 'cd /yukkuri-ranking-aggregator && bundle exec rake crawl:daily >> /var/log/cron_log.log 2>&1'" >> /etc/cron.d/crawler
