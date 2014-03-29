FROM hdemon/docker-simple-ruby-env

MAINTAINER Masami Yonehara(zeitdiebe@gmail.com)

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/ruby/bin:/home/app/.rbenv/bin:/home/app/.rbenv/shims:/home/app/.rbenv/plugins
ENV RBENV_ROOT /home/app/.rbenv
USER app

ADD ./startup.sh /home/app/startup.sh
RUN chmod +x /home/app/startup.sh

CMD ["/home/app/startup.sh"]