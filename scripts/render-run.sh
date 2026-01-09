#!/bin/sh
set -e

echo "Starting Twenty Server..."

# Set up database URL from individual variables
export PG_DATABASE_URL="postgres://postgres:${POSTGRES_PASSWORD}@${PG_DATABASE_HOST}:${PG_DATABASE_PORT}/default"

# Run database migrations
echo "Running database migrations..."
NODE_OPTIONS="--max-old-space-size=1500" yarn database:migrate:prod
echo "Database migrations completed."

# Run workspace upgrade
echo "Running workspace upgrade..."
NODE_OPTIONS="--max-old-space-size=1500" yarn command:prod upgrade

# Register background jobs
echo "Registering background sync jobs..."
NODE_OPTIONS="--max-old-space-size=1500" yarn command:prod cron:register:all || echo "Warning: Failed to register background jobs"

# Start the server
node dist/main
