#!/bin/sh
set -e

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

# Verifica se o banco de dados já existe
if rails db:version &>/dev/null; then
  echo "The database Exists. Executing migrations..."
  bundle exec rake db:migrate
else
  echo "Database not found. Setup the database and executing migrations..."
  bundle exec rake db:setup
fi

bundle exec rails s -p 3000 -b '0.0.0.0'