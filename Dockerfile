# Base image
FROM python:3.9-slim

# Install system dependencies (Nginx and Supervisor)
RUN apt-get update && \
    apt-get install -y nginx gcc python3-dev supervisor

# Copy Nginx config
COPY nginx/nginx.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Set working directory
WORKDIR /app

# Copy Python dependencies
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY main.py .
COPY core/ ./core/
COPY api/ ./api/

# Create necessary directories
RUN mkdir -p /run/nginx

# Expose port 80 for Nginx
EXPOSE 80

# Update Supervisor config
RUN echo "[supervisord]\nnodaemon=true\n\n\
[program:nginx]\ncommand=/usr/sbin/nginx -g 'daemon off;'\nautostart=true\nautorestart=true\nstartretries=5\n\n\
[program:uvicorn]\ncommand=uvicorn main:app --host 127.0.0.1 --port 8000 --workers 4\nautostart=true\nautorestart=true\nstartretries=5" \
> /etc/supervisord.conf

# Start Nginx and Uvicorn using Supervisor
CMD ["supervisord", "-c", "/etc/supervisord.conf"]