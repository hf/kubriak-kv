Kubriak KV
==========
[![Docker
Pulls](https://img.shields.io/docker/pulls/stojan/kubriak-kv.svg)](https://hub.docker.com/r/stojan/kubriak-kv/)

Kubriak KV is a Riak KV deployment for Kubernetes. It runs on top of the
[stojan/riak-kv](https://github.com/hf/stojan-kv) image and and allows for 
auto-joining clusters. 

Scaling should by using a StatefulSet instead of a Deployment since it adds
ordering to the creation of the containers.

Scaling up or down the cluster is fast and does not leave it in an
inconsistent state.

Although having kube-dns (or any DNS) in the cluster is recommended. It will
pick up a FQDN from the hostname and use it. In the case that the hostname is
not a FQDN (i.e. only a hostname) it will use the container's IP address.

This is useful if you are running a single instance for a local development
environment.

## Customization

This Docker image is published under
[stojan/kubriak-kv](https://hub.docker.com/r/stojan/kubriak-kv/). 

You can customize your image by extending from this one and copying additional
scripts into `/etc/riak/prestart.d`, `/etc/riak/poststart.d`,
`/etc/riak/prestop.d` directories.

Scripts are executed in lexicographical order (with the `XX-name.sh`
convention).

Do take a look at `poststart.d`, `prestart.d` and `prestop.d` to see the already 
included scripts.

Have in mind that the entrypoint of the image should call upon `riak-up.sh`.

Here are some environment variables which can be used to customize the Riak
cluster:

+ `RIAK_SERVICE_NAME` (default: `riak-kv`) the Kubernetes service that is the logical Riak cluster
+ `RIAK_SERVICE_NAMESPACE` (default: `default`) the Kubernetes namespace in which the
  `RIAK_SERVICE_NAME` exists
+ `RIAK_NODE_NAME` (default: `riak`) the Riak node name, i.e. `RIAK_NODE_NAME@FQDN`
+ `RIAK_DISTRIBUTED_COOKIE` (default: `riak`) the Riak distributed cookie

## Deployment

Deploying a cluster is very easy. You should create only 2 Kubernetes entities:

1. Create a Service that will expose ports 8087 and 8098.
2. Create a StatefulSet that will use a Kubriak KV image, and bind it with the
   service from (1).

You can scale your StatefulSet up and down as much as you want.

See the folder `example` for examples.

## License

This code is Copyright &copy; 2017 Stojan Dimitrovski. It is licensed under the
MIT X11 License. You can find a copy of the lincese in the file `LICENSE`
included in this distribution.

