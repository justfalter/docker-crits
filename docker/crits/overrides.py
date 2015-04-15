# DO NOT MODIFY!
#  Make your changes in /config/overrides.py

import os

# The app is mounted in the root, so we have to make sure the login url is 
# pointing to the right place. 
LOGIN_URL = '/login/'

# Override logging so that it goes to stdout/stderr -> uwsgi 
LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'formatters': {
        'verbose': {
            'format': "%(levelname)s %(asctime)s %(name)s %(message)s"
        },
    },
    'handlers': {
        'null': {
            'level': 'DEBUG',
            'class': 'django.utils.log.NullHandler',
        },
        'normal': {
            'level': LOG_LEVEL,
            'class': 'logging.StreamHandler',
            'formatter': 'verbose'
        },
    },
    'loggers': {
        'django': {
            'handlers': ['normal'],
            'propagate': True,
            'level': LOG_LEVEL,
        },
        'crits': {
            'handlers': ['normal'],
            'propagate': True,
            'level': LOG_LEVEL,
        },
    },
}

# Run user overrides
if os.path.exists('/config/overrides.py'):
    execfile('/config/overrides.py')
