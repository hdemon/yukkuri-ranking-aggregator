FROM hdemon/docker-simple-ruby-env

MAINTAINER Masami Yonehara(zeitdiebe@gmail.com)

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/ruby/bin:/home/app/.rbenv/bin:/home/app/.rbenv/shims:/home/app/.rbenv/plugins
ENV RBENV_ROOT /home/app/.rbenv

ADD ./startup.sh /home/app/startup.sh
RUN chmod +x /home/app/startup.sh

ADD ./cron_schedule /var/spool/cron/crontabs/app
ADD ./config.yml /home/app/config.yml

RUN git clone https://github.com/hdemon/yukkuri-ranking-aggregator.git /home/app/yukkuri-ranking-aggregator
RUN cd /home/app/yukkuri-ranking-aggregator && rbenv exec bundle --path vendor/bundle -j4
RUN mv /home/app/config.yml /home/app/yukkuri-ranking-aggregator/config
RUN chown -R app:app /home/app/yukkuri-ranking-aggregator

CMD ["/home/app/startup.sh"]