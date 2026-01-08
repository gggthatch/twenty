#!/bin/sh
set -e

echo "Starting Twenty Worker..."

# Set up database URL from individual variables
export PG_DATABASE_URL="postgres://postgres:${POSTGRES_PASSWORD}@${PG_DATABASE_HOST}:${PG_DATABASE_PORT}/default"

# Run database migrations if enabled (worker also needs migrations)
if [ "${DISABLE_DB_MIGRATIONS}" != "true" ]; then
    echo "Running database migrations..."
    NODE_OPTIONS="--max-old-space-size=1500" npx -y typeorm migration:run -d dist/database/typeorm/core/core.datasource.ts
    echo "Database migrations completed."
fi

# Start the worker
node dist/queue-worker/queue-worker
