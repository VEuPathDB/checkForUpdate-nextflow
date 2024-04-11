FROM ubuntu:focal

RUN apt-get -qq update --fix-missing

RUN apt-get install -y \
  wget

ADD /bin/* /usr/bin/
RUN cd /usr/bin \
  && chmod +x *.pl 

WORKDIR /work