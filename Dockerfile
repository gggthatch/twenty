FROM twentycrm/twenty:latest

# Switch to root to install packages and copy files
USER root

# Copy Render startup scripts
COPY scripts/render-run.sh /app/render-run.sh
COPY scripts/render-worker.sh /app/render-worker.sh

# Make scripts executable
RUN chmod +x /app/render-run.sh /app/render-worker.sh

# Switch back to non-root user
USER 1000

# Ensure working directory is correct
WORKDIR /app/packages/twenty-server

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:3000/healthz || exit 1

# Set custom entrypoint that can run either server or worker based on environment
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/app/render-run.sh"]
