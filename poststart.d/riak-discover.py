import os
import sys
import json
import urllib2

def read_secret(secret_name):
  secret_file = open(secret_name, 'r')
  secret = secret_file.read()
  secret_file.close()
  return secret

def pad_ip(ip):
  return '.'.join([('%03d' % int(v)) for v in ip.split('.')])

def unpad_ip(ip):
  return '.'.join([('%d' % int(v)) for v in ip.split('.')])

def field(d, field, default=None):
  if field in d:
    return d[field]
  else:
    return default

host = sys.argv[1]

kubhost = os.getenv('KUBERNETES_SERVICE_HOST', 'kubernetes')
kubport = os.getenv('KUBERNETES_SERVICE_PORT', '443')

riak_service_name = os.getenv('RIAK_SERVICE_NAME', 'riak-kv')
riak_service_namespace = os.getenv('RIAK_SERVICE_NAMESPACE', 'default')

path = '/api/v1/namespaces/' + riak_service_namespace + '/endpoints/' + riak_service_name

token = read_secret('/var/run/secrets/kubernetes.io/serviceaccount/token')

request = urllib2.Request('https://' + kubhost + ':' + kubport + path)
request.add_header('Accept', 'application/json')
request.add_header('Authorization', 'Bearer ' + token)

response = urllib2.urlopen(request)

data = json.loads(response.read())

ips = []
for subset in field(data, 'subsets', []):
  for address in field(subset, 'addresses', []):
    if 'ip' in address:
      ips += [pad_ip(address['ip'])]

ips = set(ips).difference([pad_ip(host)])
ips = list(ips)
ips.sort()

for i in xrange(len(ips)):
  ips[i] = unpad_ip(ips[i])

print(' '.join(ips))
