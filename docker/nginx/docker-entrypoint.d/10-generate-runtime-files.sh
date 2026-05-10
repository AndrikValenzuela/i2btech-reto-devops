#!/bin/sh
set -eu

: "${BASIC_AUTH_USER:=devops}"
: "${BASIC_AUTH_PASSWORD:=devops}"
: "${TLS_CN:=localhost}"

mkdir -p /etc/nginx/htpasswd /etc/nginx/certs

htpasswd -bc /etc/nginx/htpasswd/users "$BASIC_AUTH_USER" "$BASIC_AUTH_PASSWORD"

if [ ! -f /etc/nginx/certs/tls.crt ] || [ ! -f /etc/nginx/certs/tls.key ]; then
  openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -subj "/CN=${TLS_CN}" \
    -keyout /etc/nginx/certs/tls.key \
    -out /etc/nginx/certs/tls.crt
fi
