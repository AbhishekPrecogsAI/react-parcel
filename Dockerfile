# Intentionally using an old vulnerable base image
FROM node:14

# Hardcoded secret (bad practice)
ENV SECRET_KEY="super-secret-key"

# Set working directory
WORKDIR /app

# Copy all files
COPY . .

# Install dependencies (without lockfile verification)
RUN npm install

# Expose application port
EXPOSE 3000

# Run as root (security issue)
USER root

# Start application
CMD ["node", "server.js"]
