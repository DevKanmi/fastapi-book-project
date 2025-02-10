# Base image
FROM python:3.9-slim

# Install system dependencies (Nginx)
RUN apt-get update && \
    apt-get install -y nginx gcc python3-dev

# Copy Nginx config
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

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

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx and Uvicorn
CMD service nginx start && uvicorn main:app --host 0.0.0.0 --port 8000