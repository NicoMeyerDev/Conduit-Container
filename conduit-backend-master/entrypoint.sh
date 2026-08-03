#!/bin/sh
python manage.py migrate
exec gunicorn conduit.wsgi:application --bind 0.0.0.0:${APPLICATION_PORT}