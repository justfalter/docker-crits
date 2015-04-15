import sys,os
# Run user DB config
if os.path.exists('/config/database.py'):
    execfile('/config/database.py')
else:
    print("************************************************************")
    print("ERROR: Cannot start CRITs without /config/database.py!")
    print("************************************************************")
    sys.exit(1)


