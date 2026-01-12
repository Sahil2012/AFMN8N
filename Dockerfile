FROM n8nio/n8n:2.0.3

USER root

# Install Python and Supervisor
RUN apk add --update --no-cache \
    python3 py3-pip python3-dev build-base linux-headers \
    supervisor

# Create virtual environment for Python (optional but good for consistency)
USER node
RUN python3 -m venv /home/node/python_venv
RUN /home/node/python_venv/bin/pip install --no-cache-dir pandas requests numpy

# Copy supervisor config
USER root
COPY supervisord.conf /etc/supervisord.conf

ENV N8N_PYTHON_BINARY=/home/node/python_venv/bin/python

# Entrypoint via Supervisor
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
