#!/bin/sh

echo "Waiting for postgres..."

while ! nc -z $SQL_HOST $SQL_PORT; do
  sleep 0.1
done

sleep 2

echo "PostgreSQL started"

echo "Running migrations..."
python manage.py makemigrations --no-input
python manage.py migrate --no-input


if [ "${ENV}" = "prod" ]; then
    uwsgi --uid appuser --gid appuser --socket :8000 --workers 4 --master --enable-threads --module main.wsgi
else
    python manage.py runserver 0.0.0.0:8000
fi