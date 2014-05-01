FROM hdemon/simple-ruby-env

MAINTAINER Masami Yonehara(zeitdiebe@gmail.com)

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/ruby/bin:/home/app/.rbenv/bin:/home/app/.rbenv/shims:/home/app/.rbenv/plugins
ENV RBENV_ROOT /home/app/.rbenv
USER app

ADD ./database.yml /tmp/database.yml
ADD ./startup.sh /home/app/startup.sh
RUN chmod +x /home/app/startup.sh

cd /home/app
git clone https://github.com/hdemon/yukkuri-ranking-aggregator.git
cp /tmp/database.yml /home/app/yukkuri-ranking-aggregator/config/database.yml
cd /home/app/yukkuri-ranking-aggregator
rbenv exec bundle --path vendor/bundle -j4
rbenv exec bundle exec rake db:create RAILS_ENV=production
rbenv exec bundle exec rake db:migrate RAILS_ENV=production
