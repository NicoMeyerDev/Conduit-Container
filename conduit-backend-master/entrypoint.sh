#!/bin/sh
python manage.py migrate
python manage.py createsuperuser --noinput --username "$DJANGO_SUPERUSER_USERNAME" --email "$DJANGO_SUPERUSER_EMAIL" || true
exec gunicorn conduit.wsgi:application --bind 0.0.0.0:${APPLICATION_PORT}