FROM twentycrm/twenty:latest

# Install postgresql client for migrations
RUN apk add --no-cache postgresql-client

# Copy Render startup scripts
COPY scripts/render-run.sh /app/render-run.sh
COPY scripts/render-worker.sh /app/render-worker.sh

# Make scripts executable
RUN chmod +x /app/render-run.sh /app/render-worker.sh

# Ensure working directory is correct
WORKDIR /app/packages/twenty-server

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:3000/healthz || exit 1

# Default command will be overridden by dockerCommand in render.yaml
CMD ["node", "dist/main"]
