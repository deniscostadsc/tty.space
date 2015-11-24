#!/bin/bash

kickstart.context 'SSL'

kickstart.info "LETSENCRYPT_EMAIL variable must be set to use the ssl role"
kickstart.info "Requesting it over stdin"
read -r LETSENCRYPT_EMAIL
export LETSENCRYPT_EMAIL

# Dependencies for letsencrypt
kickstart.package.install git
kickstart.package.install python2
kickstart.package.install python-virtualenv
kickstart.package.install gcc
kickstart.package.install dialog
kickstart.package.install augeas
kickstart.package.install openssl
kickstart.package.install libffi
kickstart.package.install ca-certificates
kickstart.package.install pkg-config

rm -rf /tmp/letsencrypt
git clone https://github.com/letsencrypt/letsencrypt /tmp/letsencrypt

generate-cert() {
(
cd /tmp/letsencrypt
./letsencrypt-auto certonly \
  -a webroot \
  --webroot-path /var/web \
  --domains tty.space \
  --server https://acme-v01.api.letsencrypt.org/directory \
  --agree-dev-preview \
  --agree-tos \
  --text \
  --email "$LETSENCRYPT_EMAIL"
)
}

! [ -d /etc/letsencrypt/live/tty.space ] && generate-cert

kickstart.info 'SSL Installed'