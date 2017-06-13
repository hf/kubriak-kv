FROM centos:7

ENV RIAK_VERSION 2.2.3-1
ENV RIAK_NODE_NAME riak
ENV RIAK_DISTRIBUTED_COOKIE riak

COPY prestart.d /etc/riak/prestart.d
COPY poststart.d /etc/riak/poststart.d
COPY riak-cluster.sh /home/root/

WORKDIR /home/root

ADD http://s3.amazonaws.com/downloads.basho.com/riak/2.2/2.2.3/rhel/7/riak-${RIAK_VERSION}.el7.centos.x86_64.rpm ./

RUN yum install -y riak-${RIAK_VERSION}.el7.centos.x86_64.rpm

EXPOSE 8087 8089

CMD ["/bin/bash", "riak-cluster.sh"]
