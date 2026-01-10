FROM n8nio/n8n:2.0.3

USER root

# 1. Install Python and dependencies
RUN apk add --update --no-cache python3 py3-pip python3-dev build-base linux-headers

# 2. Create the virtual environment n8n expects
# We put it in /home/node/python_venv
RUN python3 -m venv /home/node/python_venv

# 3. Install libraries INTO that virtual environment
RUN /home/node/python_venv/bin/pip install --no-cache-dir pandas requests numpy

# 4. Set permissions so the 'node' user can access it
RUN chown -R node:node /home/node/python_venv

USER node

# 5. Tell n8n to use this specific virtual environment
ENV N8N_PYTHON_BINARY=/home/node/python_venv/bin/python