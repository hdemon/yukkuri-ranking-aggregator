FROM hdemon/docker-simple-ruby-env

MAINTAINER Masami Yonehara(zeitdiebe@gmail.com)

ENV PATH $PATH:/usr/ruby/bin

USER app

ADD ./startup.sh /home/app/startup.sh
RUN chmod +x /home/app/startup.sh

CMD ["/home/app/startup.sh"]