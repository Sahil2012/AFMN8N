FROM n8nio/n8n:2.0.3

USER root

# Install Python, Redis, supervisor
RUN apk add --update --no-cache \
    python3 py3-pip python3-dev build-base linux-headers \
    redis supervisor

# Create virtual environment
RUN python3 -m venv /home/node/python_venv
RUN /home/node/python_venv/bin/pip install --no-cache-dir pandas requests numpy
RUN chown -R node:node /home/node/python_venv

# DEBUG: Find where the task runner actually is
RUN echo "=== Searching for task runner ===" && \
    find /usr/local -name "*task*" -o -name "*runner*" 2>/dev/null | head -20 && \
    echo "=== Checking n8n structure ===" && \
    ls -la /usr/local/lib/node_modules/n8n/ && \
    echo "=== Checking dist folder ===" && \
    ls -la /usr/local/lib/node_modules/n8n/dist/ 2>/dev/null || echo "No dist folder"

# Copy supervisor config
COPY supervisord.conf /etc/supervisord.conf

ENV N8N_PYTHON_BINARY=/home/node/python_venv/bin/python
ENV N8N_RUNNERS_MODE=external
ENV N8N_RUNNERS_TASK_BROKER_URI=redis://localhost:6379

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]