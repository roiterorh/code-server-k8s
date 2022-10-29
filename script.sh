#!/usr/bin/env bash

CA_CRT=$(cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt |base64 -w0)
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token )
mkdir -p /home/coder/.kube
cat >/home/coder/.kube/config <<EOL
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${CA_CRT}
    server: https://${KUBERNETES_PORT_443_TCP_ADDR}:443
  name: default
contexts:
- context:
    cluster: default
    user: default
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: default
  user:
    token: ${TOKEN}
EOL
chmod 400 /home/coder/.kube/config

dumb-init fixuid -q code-server --bind-addr 0.0.0.0:8080 --disable-telemetry --disable-update-check --auth none .