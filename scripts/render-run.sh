#!/bin/sh
set -e

echo "Starting Twenty Server..."

# Set up database URL from individual variables
export PG_DATABASE_URL="postgres://postgres:${POSTGRES_PASSWORD}@${PG_DATABASE_HOST}:${PG_DATABASE_PORT}/default"

# Run database migrations
echo "Running database migrations..."
NODE_OPTIONS="--max-old-space-size=1500" npx -y typeorm migration:run -d dist/database/typeorm/core/core.datasource.ts
echo "Database migrations completed."

# Register background jobs
echo "Registering background sync jobs..."
node dist/command/main.mjs command workspace:sync-metadata || echo "Warning: Failed to register background jobs"

# Start the server
node dist/main
