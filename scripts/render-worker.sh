#!/bin/sh
set -e

echo "Starting Twenty Worker..."

# Set up database URL from individual variables
export PG_DATABASE_URL="postgres://postgres:${POSTGRES_PASSWORD}@${PG_DATABASE_HOST}:${PG_DATABASE_PORT}/default"

# Worker does not run migrations (server handles them)
echo "Skipping migrations (handled by server)..."

# Start the worker
yarn worker:prod
