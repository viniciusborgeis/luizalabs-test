#!/bin/sh
set -e

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

if rails db:version &>/dev/null; then
  echo "The database Exists. Executing migrations..."
  rails db:migrate
else
  echo "Database not found. Setup the database and executing migrations..."
  rails db:create
  rails db:migrate
fi

bundle exec rails s -p 3000 -b '0.0.0.0'