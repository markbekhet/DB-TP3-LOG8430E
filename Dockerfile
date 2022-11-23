FROM ubuntu
RUN mkdir /root/cassandra
RUN mkdir /root/Mongo
RUN mkdir /root/redis
RUN apt update
RUN apt -y install sudo
RUN apt -y install docker
RUN apt -y install docker-compose
RUN apt -y install maven
RUN apt -y install git
RUN apt -y install python2
RUN apt -y install python3-virtualenv
RUN apt -y install python2-pip-whl
RUN apt -y install python2-setuptools-whl
RUN apt -y install openjdk-11-jdk