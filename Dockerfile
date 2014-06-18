FROM debian
MAINTAINER "Christoph Trautwein <christoph.trautwein@sinnerschrader.com>"

ENV DEBIAN_FRONTEND noninteractive 
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN apt-get -qq update

ADD etc/timezone /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN apt-get -y install less
RUN apt-get -y install vim

CMD /bin/bash
