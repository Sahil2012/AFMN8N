FROM n8nio/n8n:2.0.3

USER root

RUN apk add --update --no-cache \
    python3 py3-pip python3-dev build-base linux-headers \
    redis bash su-exec

# Create the virtual environment
RUN python3 -m venv /home/node/python_venv

# Install Python libraries
RUN /home/node/python_venv/bin/pip install --no-cache-dir pandas requests numpy

# Set permissions
RUN chown -R node:node /home/node/python_venv

# Create supervisor config to run multiple processes
COPY supervisord.conf /etc/supervisord.conf

USER node

# At the end of Dockerfile, should be:
ENV N8N_PYTHON_BINARY=/home/node/python_venv/bin/python
ENV N8N_RUNNERS_MODE=external
ENV N8N_RUNNERS_TASK_BROKER_URI=redis://localhost:6379

# Stay as root for supervisor
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]