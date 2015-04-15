#!/usr/bin/python
import socket, sys, time

interval = 1
attempts = 60
GRIDFS=1
execfile('/data/crits/crits/config/database.py')

for x in xrange(1,attempts):
  print "Trying to reach %s:%d" % (MONGO_HOST, MONGO_PORT)
  start = time.time()
  try:
    sock = socket.create_connection((MONGO_HOST,MONGO_PORT), 1)
    print "Success!"
    sys.exit(0)
  except SystemExit as e:
    sys.exit(e.code)
  except:
    pass
  finally:
    try:
      sock.close()
    except:
      pass
  sleepfor = interval - (time.time() - start)
  if (sleepfor > 0):
    time.sleep(sleepfor)

print "Failed to reach %s:%d!" % (MONGO_HOST, MONGO_PORT)
sys.exit(1)
