import os

os.environ['PYTHON_EGG_CACHE'] = '/tmp'
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'crits.settings')

# This application object is used by the development server
# as well as any WSGI server configured to use this file.
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()

# Mod to django to load before forking!
application.load_middleware()
from django.core.handlers.wsgi import WSGIRequest
from io import BytesIO
req = WSGIRequest({'REQUEST_METHOD':'GET','PATH_INFO':'', 'wsgi.input':BytesIO(b''),'SERVER_NAME':'foo','SERVER_PORT':'80'})
application.get_response(req)

