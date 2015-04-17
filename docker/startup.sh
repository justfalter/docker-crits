#!/bin/bash
set -e

if [ "$1" = "data-only" ]; then
  exec /bin/true
fi

make -f /docker/Makefile crits
if [ "$1" = "start" ]; then
  exec uwsgi --die-on-term --ini /docker/uwsgi/uwsgi.ini 
else
  exec "$@"
fi
