#!/bin/sh
set -e

echo "Starting Twenty Server..."

# Debug: Show environment variables
echo "PG_DATABASE_HOST=${PG_DATABASE_HOST}"
echo "PG_DATABASE_PORT=${PG_DATABASE_PORT}"
echo "REDIS_HOST=${REDIS_HOST}"
echo "REDIS_PORT=${REDIS_PORT}"

# Set up database URL from individual variables
export PG_DATABASE_URL="postgres://postgres:${POSTGRES_PASSWORD}@${PG_DATABASE_HOST}:${PG_DATABASE_PORT}/default"

# Set up Redis URL
export REDIS_URL="redis://${REDIS_HOST}:${REDIS_PORT}"

# Debug: Show constructed URLs
echo "PG_DATABASE_URL=${PG_DATABASE_URL}"
echo "REDIS_URL=${REDIS_URL}"

# Wait for database to be ready
echo "Waiting for database to be ready..."
for i in $(seq 1 30); do
  if nc -zv ${PG_DATABASE_HOST} ${PG_DATABASE_PORT} 2>&1 | grep -q succeeded; then
    echo "Database is ready!"
    break
  fi
  echo "Waiting for database... ($i/30)"
  sleep 2
done

# Run database migrations
echo "Running database migrations..."
NODE_OPTIONS="--max-old-space-size=1500" yarn database:migrate:prod || {
  echo "Database migrations failed!"
  exit 1
}
echo "Database migrations completed."

# Run workspace upgrade
echo "Running workspace upgrade..."
NODE_OPTIONS="--max-old-space-size=1500" yarn command:prod upgrade || {
  echo "Workspace upgrade failed!"
  exit 1
}

# Register background jobs
echo "Registering background sync jobs..."
NODE_OPTIONS="--max-old-space-size=1500" yarn command:prod cron:register:all || echo "Warning: Failed to register background jobs"

# Start the server
echo "Starting server..."
node dist/main

# Start the server
node dist/main
