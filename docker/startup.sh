#!/bin/bash
set -e

make -f /docker/Makefile crits
if [ "$1" = "start" ]; then
  exec uwsgi --plugin python --ini /docker/uwsgi/uwsgi.ini 
else
  echo "Starting: $@"
  exec "$@"
fi
