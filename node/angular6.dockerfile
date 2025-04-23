FROM node:14-alpine

WORKDIR /app

# Install Angular CLI globally
RUN npm install -g @angular/cli@6.2.9

# Install additional dependencies if needed
RUN apk add --no-cache git

# Expose port 4200
EXPOSE 4200
