#!/bin/bash
set -e

echo "Starting Redis..."
redis-server --bind 127.0.0.1 --daemonize yes

# Wait for Redis to be ready
echo "Waiting for Redis..."
until redis-cli ping 2>/dev/null; do
  sleep 1
done
echo "Redis is ready!"

# Start task runner in background
echo "Starting task runner..."
su-exec node n8n task-runner &

# Give task runner a moment to initialize
sleep 2

# Start n8n (foreground)
echo "Starting n8n..."
exec su-exec node n8n start