Kubriak KV
==========
[![Docker
Pulls](https://img.shields.io/docker/pulls/stojan/kubriak-kv.svg)](https://hub.docker.com/r/stojan/kubriak-kv/)

Kubriak KV is a Riak KV deployment for Kubernetes. It runs in a CentOS 7
container and allows for auto-joining clusters. Scaling of the cluster is
achieved via a StatefulSet rather than a Deployment / ReplicaSet due to
achieving better and more stable results for the auto-join functionality.

Scaling up or down the cluster is fast and does not leave it in an
inconsistent state.

It does require the use of kube-dns and the service being available on the
Kubernetes cluster prior to deploying Kubriak KV.

## Customization

This Docker image is published under
[stojan/kubriak-kv](https://hub.docker.com/r/stojan/kubriak-kv/). 

You can customize your image by extending from this one and copying additional
scripts into `/etc/riak/prestart.d` and `/etc/riak/poststart.d` directories.
Scripts are executed in lexicographical order (with the `XX-name.sh`
convention).

Do take a look at `poststart.d` and `prestart.d` to see the already included
scripts.

Have in mind that the entrypoint of the image should still be `riak-cluster.sh`
in order for it to work.

Here are some environment variables which can be used to customize the Riak
cluster:

+ `RIAK_SERVICE_NAME` (default: `riak-kv`) the Kubernetes service that is the logical Riak cluster
+ `RIAK_SERVICE_NAMESPACE` (default: `default`) the Kubernetes namespace in which the
  `RIAK_SERVICE_NAME` exists
+ `RIAK_NODE_NAME` (default: `riak`) the Riak node name, i.e. `RIAK_NODE_NAME@FQDN`
+ `RIAK_DISTRIBUTED_COOKIE` (default: `riak`) the Riak distributed cookie

## Deployment

Deploying a cluster is very easy. You should create only 2 Kubernetes entities:

1. Create a service (headless) that will expose ports 8087 and 8089.
2. Create a StatefulSet that will use a Kubriak KV image, and bind it with the
   service from (1).

You can scale your StatefulSet up and down as much as you want.

See the folder `example` for examples.

## License

This code is Copyright &copy; 2017 Stojan Dimitrovski. It is licensed under the
MIT X11 License. You can find a copy of the lincese in the file `LICENSE`
included in this distribution.

