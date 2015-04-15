#!/usr/bin/env python
import os, sys, time
import mongoengine.connection
from django.core.management import ManagementUtility

attempts = 60
interval = 1

sys.path.append('/data/crits')
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "crits.settings")
for x in xrange(1,attempts):
  start = time.time()
  print "Trying to validate CRITs configuration..."
  try:
    ManagementUtility().fetch_command('validate').execute()
    print "Success"
    sys.exit(0)
  except mongoengine.connection.ConnectionError as e:
    print "Connection to mongodb failed: %s" % (e.message)
    print "Retrying in case server just isn't up, yet..."
    pass

  sleepfor = interval - (time.time() - start)
  if (sleepfor > 0):
    time.sleep(sleepfor)

print "Failed to validate configuration"
sys.exit(1)
