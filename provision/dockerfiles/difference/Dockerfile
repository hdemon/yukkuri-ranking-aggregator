FROM hdemon/yukkuri-ranking-aggregator-base

MAINTAINER Masami Yonehara(zeitdiebe@gmail.com)

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/ruby/bin:/home/app/.rbenv/bin:/home/app/.rbenv/shims:/home/app/.rbenv/plugins
ENV RBENV_ROOT /home/app/.rbenv
USER app

cd /home/app/yukkuri-ranking-aggregator
git pull origin master
rbenv exec bundle update
rbenv exec bundle exec rake db:create RAILS_ENV=production
rbenv exec bundle exec rake db:migrate RAILS_ENV=production
