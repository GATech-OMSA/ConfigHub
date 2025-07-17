# Docker Master Guide: Complete Reference

## Table of Contents
1. [Docker Fundamentals](#docker-fundamentals)
2. [Essential Docker Commands](#essential-docker-commands)
3. [Working with Images](#working-with-images)
4. [Container Management](#container-management)
5. [Dockerfile Best Practices](#dockerfile-best-practices)
6. [Docker Compose](#docker-compose)
7. [Networking in Docker](#networking-in-docker)
8. [Volume Management](#volume-management)
9. [Docker Registry](#docker-registry)
10. [Security Best Practices](#security-best-practices)
11. [Performance Optimization](#performance-optimization)
12. [Debugging and Troubleshooting](#debugging-and-troubleshooting)
13. [Docker in Development](#docker-in-development)
14. [Docker in Production](#docker-in-production)
15. [Maintenance and Cleanup](#maintenance-and-cleanup)
16. [Advanced Topics](#advanced-topics)
17. [Quick Reference](#quick-reference)

## Docker Fundamentals

### What is Docker?
Docker is a platform for developing, shipping, and running applications in containers. Containers package code and dependencies together, ensuring consistency across different environments.

### Key Concepts
- **Image**: A read-only template containing application code, runtime, libraries, and dependencies
- **Container**: A runnable instance of an image
- **Dockerfile**: A text file containing instructions to build a Docker image
- **Registry**: A repository for Docker images (e.g., Docker Hub)
- **Volume**: Persistent data storage for containers
- **Network**: Communication layer between containers

## Essential Docker Commands

### System Information
```bash
# Docker version
docker version

# System-wide information
docker info

# Check Docker system status
docker system df

# View Docker system events
docker system events
```

### Getting Help
```bash
# General help
docker --help

# Command-specific help
docker run --help
docker build --help
```

## Working with Images

### Pulling Images
```bash
# Pull latest image
docker pull nginx

# Pull specific version
docker pull nginx:1.21

# Pull from different registry
docker pull gcr.io/project-id/image-name
```

### Listing Images
```bash
# List all images
docker images

# List with filter
docker images -f "dangling=true"

# List with format
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
```

### Building Images
```bash
# Build from Dockerfile in current directory
docker build -t myapp:latest .

# Build from specific Dockerfile
docker build -f Dockerfile.dev -t myapp:dev .

# Build with build arguments
docker build --build-arg VERSION=1.0 -t myapp:1.0 .

# Build without cache
docker build --no-cache -t myapp:latest .

# Build with target stage
docker build --target production -t myapp:prod .
```

### Managing Images
```bash
# Tag an image
docker tag myapp:latest myapp:v1.0

# Remove an image
docker rmi myapp:v1.0

# Remove all unused images
docker image prune

# Remove all images
docker rmi $(docker images -q)

# Save image to tar
docker save -o myapp.tar myapp:latest

# Load image from tar
docker load -i myapp.tar
```

## Container Management

### Running Containers
```bash
# Run a container
docker run nginx

# Run in detached mode
docker run -d nginx

# Run with name
docker run -d --name webserver nginx

# Run with port mapping
docker run -d -p 8080:80 nginx

# Run with environment variables
docker run -d -e NODE_ENV=production myapp

# Run with volume
docker run -d -v /host/path:/container/path nginx

# Run with restart policy
docker run -d --restart=always nginx

# Run interactively
docker run -it ubuntu bash

# Run with resource limits
docker run -d --memory="1g" --cpus="0.5" nginx
```

### Container Operations
```bash
# List running containers
docker ps

# List all containers
docker ps -a

# Stop container
docker stop container_name

# Start container
docker start container_name

# Restart container
docker restart container_name

# Remove container
docker rm container_name

# Remove all stopped containers
docker container prune

# Force remove running container
docker rm -f container_name
```

### Interacting with Containers
```bash
# Execute command in running container
docker exec -it container_name bash

# View container logs
docker logs container_name

# Follow logs
docker logs -f container_name

# View last 100 lines
docker logs --tail 100 container_name

# Copy files to/from container
docker cp file.txt container_name:/path/
docker cp container_name:/path/file.txt .

# Inspect container
docker inspect container_name

# View container stats
docker stats

# View container processes
docker top container_name
```

## Dockerfile Best Practices

### Basic Dockerfile Structure
```dockerfile
# Base image
FROM node:16-alpine

# Metadata
LABEL maintainer="your-email@example.com"
LABEL description="Application description"

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

# Start command
CMD ["node", "server.js"]
```

### Multi-stage Builds
```dockerfile
# Build stage
FROM node:16-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY --from=builder /app/dist ./dist
USER node
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

### Optimization Tips
```dockerfile
# 1. Order layers from least to most frequently changing
FROM node:16-alpine
WORKDIR /app

# Dependencies change less frequently
COPY package*.json ./
RUN npm ci

# Application code changes frequently
COPY . .

# 2. Minimize layers
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    && rm -rf /var/lib/apt/lists/*

# 3. Use specific versions
FROM node:16.14.2-alpine3.15

# 4. Use .dockerignore
# Create .dockerignore file:
# node_modules
# .git
# .env
# *.log
# .DS_Store
```

## Docker Compose

### Basic docker-compose.yml
```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    depends_on:
      - db
    volumes:
      - ./app:/app
      - /app/node_modules
    restart: unless-stopped

  db:
    image: postgres:13
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:

networks:
  default:
    name: myapp_network
```

### Docker Compose Commands
```bash
# Start services
docker-compose up

# Start in detached mode
docker-compose up -d

# Build and start
docker-compose up --build

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# View logs
docker-compose logs

# Follow logs for specific service
docker-compose logs -f web

# Execute command in service
docker-compose exec web bash

# Scale service
docker-compose up -d --scale web=3

# View running services
docker-compose ps

# Pull latest images
docker-compose pull

# Validate compose file
docker-compose config
```

### Advanced Compose Features
```yaml
version: '3.8'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile.prod
      args:
        - BUILD_VERSION=1.0
    image: myapp:latest
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## Networking in Docker

### Network Types
```bash
# List networks
docker network ls

# Create custom network
docker network create myapp-network

# Create network with options
docker network create \
  --driver bridge \
  --subnet 172.20.0.0/16 \
  --ip-range 172.20.240.0/20 \
  myapp-network

# Connect container to network
docker network connect myapp-network container_name

# Disconnect from network
docker network disconnect myapp-network container_name

# Inspect network
docker network inspect myapp-network

# Remove network
docker network rm myapp-network
```

### Container Communication
```bash
# Run containers on same network
docker run -d --name db --network myapp-network postgres
docker run -d --name web --network myapp-network -e DB_HOST=db myapp

# Expose ports
docker run -d -p 8080:80 nginx  # Host:Container
docker run -d -P nginx  # Random host ports

# Multiple port mappings
docker run -d \
  -p 8080:80 \
  -p 8443:443 \
  nginx
```

## Volume Management

### Types of Volumes
```bash
# Named volumes (preferred)
docker volume create myapp-data
docker run -v myapp-data:/data myapp

# Bind mounts
docker run -v /host/path:/container/path myapp

# Anonymous volumes
docker run -v /data myapp

# Read-only volumes
docker run -v /host/path:/container/path:ro myapp
```

### Volume Operations
```bash
# List volumes
docker volume ls

# Create volume
docker volume create myapp-data

# Inspect volume
docker volume inspect myapp-data

# Remove volume
docker volume rm myapp-data

# Remove all unused volumes
docker volume prune

# Backup volume
docker run --rm \
  -v myapp-data:/source \
  -v $(pwd):/backup \
  alpine tar czf /backup/backup.tar.gz -C /source .

# Restore volume
docker run --rm \
  -v myapp-data:/target \
  -v $(pwd):/backup \
  alpine tar xzf /backup/backup.tar.gz -C /target
```

## Docker Registry

### Docker Hub Operations
```bash
# Login to Docker Hub
docker login

# Push image
docker tag myapp:latest username/myapp:latest
docker push username/myapp:latest

# Pull private image
docker pull username/myapp:latest

# Logout
docker logout
```

### Private Registry
```bash
# Run local registry
docker run -d -p 5000:5000 --name registry registry:2

# Tag for local registry
docker tag myapp localhost:5000/myapp

# Push to local registry
docker push localhost:5000/myapp

# Pull from local registry
docker pull localhost:5000/myapp

# With authentication
docker run -d \
  -p 5000:5000 \
  --name registry \
  -v /path/to/auth:/auth \
  -e REGISTRY_AUTH=htpasswd \
  -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  registry:2
```

## Security Best Practices

### 1. Use Official Images
```dockerfile
# Good
FROM node:16-alpine

# Better - specify exact version
FROM node:16.14.2-alpine3.15
```

### 2. Run as Non-Root User
```dockerfile
# Create user in Dockerfile
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

USER nodejs
```

### 3. Scan for Vulnerabilities
```bash
# Using Docker Scout
docker scout cves myapp:latest

# Using Trivy
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image myapp:latest
```

### 4. Use Secrets
```bash
# Create secret
echo "mypassword" | docker secret create db_password -

# Use in service
docker service create \
  --name web \
  --secret db_password \
  myapp

# In compose
version: '3.8'
secrets:
  db_password:
    file: ./db_password.txt

services:
  web:
    image: myapp
    secrets:
      - db_password
```

### 5. Security Scanning in CI/CD
```yaml
# GitHub Actions example
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'myapp:latest'
    format: 'sarif'
    output: 'trivy-results.sarif'
```

## Performance Optimization

### 1. Image Size Optimization
```dockerfile
# Use alpine images
FROM node:16-alpine

# Multi-stage builds
FROM node:16 AS builder
WORKDIR /app
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html

# Remove unnecessary files
RUN rm -rf /var/cache/apk/*
```

### 2. Build Cache Optimization
```dockerfile
# Order matters - least changing first
FROM node:16-alpine
WORKDIR /app

# Dependencies change less often
COPY package*.json ./
RUN npm ci

# Code changes more often
COPY . .
RUN npm run build
```

### 3. Container Resource Limits
```bash
# Memory limit
docker run -m 512m myapp

# CPU limit
docker run --cpus="1.5" myapp

# In compose
services:
  web:
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
```

## Debugging and Troubleshooting

### Container Debugging
```bash
# Debug failed container
docker logs container_name
docker inspect container_name

# Access stopped container files
docker run --rm -it -v /var/lib/docker:/docker alpine \
  ls /docker/containers/

# Debug networking
docker run --rm -it nicolaka/netshoot
nslookup service_name
curl http://service_name

# Debug file permissions
docker run --rm -it -v $(pwd):/debug alpine \
  ls -la /debug
```

### Common Issues and Solutions

#### 1. Container Exits Immediately
```bash
# Check logs
docker logs container_name

# Run interactively to debug
docker run -it myapp /bin/sh
```

#### 2. Permission Denied
```dockerfile
# Fix in Dockerfile
RUN chown -R node:node /app
USER node
```

#### 3. Cannot Connect to Container
```bash
# Check if container is running
docker ps

# Check port mapping
docker port container_name

# Check network
docker network inspect bridge
```

#### 4. Out of Space
```bash
# Check disk usage
docker system df

# Clean up
docker system prune -a
```

## Docker in Development

### Development Workflow
```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/app
      - /app/node_modules
    ports:
      - "3000:3000"
      - "9229:9229"  # Debug port
    environment:
      - NODE_ENV=development
    command: npm run dev
```

### Hot Reload Setup
```dockerfile
# Dockerfile.dev
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
EXPOSE 3000 9229
CMD ["npm", "run", "dev"]
```

### VS Code Integration
```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "attach",
      "name": "Docker: Attach to Node",
      "port": 9229,
      "address": "localhost",
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/app",
      "protocol": "inspector"
    }
  ]
}
```

## Docker in Production

### Production Checklist
- [ ] Use specific image tags, not `latest`
- [ ] Implement health checks
- [ ] Set resource limits
- [ ] Use non-root user
- [ ] Enable logging
- [ ] Set restart policies
- [ ] Use secrets for sensitive data
- [ ] Implement monitoring
- [ ] Regular security scanning
- [ ] Backup strategy for volumes

### Production Compose Example
```yaml
version: '3.8'

services:
  web:
    image: myapp:1.2.3
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    secrets:
      - db_password
    environment:
      - NODE_ENV=production

secrets:
  db_password:
    external: true
```

## Maintenance and Cleanup

### Regular Cleanup Commands
```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Remove everything unused
docker system prune

# Remove everything including volumes
docker system prune -a --volumes

# Automated cleanup script
#!/bin/bash
echo "🧹 Docker Cleanup Script"
echo "======================="

echo "Before cleanup:"
docker system df

echo -e "\nRemoving stopped containers..."
docker container prune -f

echo -e "\nRemoving unused images..."
docker image prune -a -f

echo -e "\nRemoving unused volumes..."
docker volume prune -f

echo -e "\nRemoving unused networks..."
docker network prune -f

echo -e "\nAfter cleanup:"
docker system df
```

### Monitoring Disk Usage
```bash
# Check Docker disk usage
docker system df

# Detailed usage
docker ps -s  # Container sizes
docker images -a  # All images
docker volume ls  # List volumes

# Find large containers
docker ps -a --format "table {{.Names}}\t{{.Size}}"
```

## Advanced Topics

### Docker Build Kit
```bash
# Enable BuildKit
export DOCKER_BUILDKIT=1

# Build with BuildKit
DOCKER_BUILDKIT=1 docker build -t myapp .

# In Dockerfile - mount secrets
# syntax=docker/dockerfile:1
FROM alpine
RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret

# Build with secret
docker build --secret id=mysecret,src=mysecret.txt .
```

### Docker Context
```bash
# List contexts
docker context ls

# Create new context
docker context create remote --docker "host=ssh://user@remotehost"

# Use context
docker context use remote

# Remove context
docker context rm remote
```

### Docker Plugins
```bash
# Install plugin
docker plugin install vieux/sshfs

# List plugins
docker plugin ls

# Enable/disable plugin
docker plugin enable vieux/sshfs
docker plugin disable vieux/sshfs

# Remove plugin
docker plugin rm vieux/sshfs
```

## Quick Reference

### Essential Commands Cheat Sheet
```bash
# Images
docker pull image:tag          # Download image
docker build -t name .         # Build image
docker images                  # List images
docker rmi image              # Remove image

# Containers
docker run image              # Run container
docker ps                     # List running
docker ps -a                  # List all
docker stop container         # Stop container
docker rm container           # Remove container
docker logs container         # View logs
docker exec -it container sh  # Access container

# Compose
docker-compose up -d          # Start services
docker-compose down           # Stop services
docker-compose logs -f        # View logs
docker-compose ps             # List services

# Cleanup
docker system prune -a        # Remove all unused
docker volume prune           # Remove unused volumes
docker container prune        # Remove stopped containers

# Registry
docker login                  # Login to registry
docker push image            # Push image
docker pull image            # Pull image

# Debugging
docker inspect container      # Detailed info
docker stats                 # Resource usage
docker top container         # Running processes
```

### Common Docker Run Options
```bash
docker run \
  -d \                        # Detached mode
  --name myapp \              # Container name
  -p 8080:80 \               # Port mapping
  -v /host:/container \       # Volume mount
  -e VAR=value \             # Environment variable
  --restart=always \          # Restart policy
  --memory=1g \              # Memory limit
  --cpus=2 \                 # CPU limit
  --network=mynet \          # Custom network
  --health-cmd="curl localhost" \  # Health check
  image:tag
```

### Dockerfile Instructions
```dockerfile
FROM          # Base image
RUN           # Execute command
CMD           # Default command
ENTRYPOINT    # Main command
COPY          # Copy files
ADD           # Add files (can extract archives)
WORKDIR       # Set working directory
EXPOSE        # Document ports
ENV           # Set environment variable
ARG           # Build argument
VOLUME        # Create volume mount point
USER          # Set user
LABEL         # Add metadata
HEALTHCHECK   # Define health check
```

---

Remember: Docker is powerful but requires careful consideration of security, performance, and maintenance. Always follow best practices and keep your images updated!