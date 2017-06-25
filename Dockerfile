FROM stojan/riak-kv

COPY prestart.d /etc/riak/prestart.d
COPY poststart.d /etc/riak/poststart.d
COPY prestop.d /etc/riak/prestop.d

COPY probes.d /etc/riak/probes.d

COPY iskube.sh /usr/local/bin/

