#!/bin/bash
set -e

rm /etc/nginx/conf.d/*
ln -sfv /data/crits.conf /etc/nginx/conf.d/crits.conf
perl /data/generate_crits_upstream.pl > /etc/nginx/conf.d/crits_upstream.conf

if [ ! -f /root/crits.dev.crt ]; then
  pushd /root
  /bin/bash /data/gencert.sh crits.dev
  popd
fi

exec nginx -g "daemon off;"
