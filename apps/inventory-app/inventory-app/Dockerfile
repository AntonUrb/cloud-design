# Use the penultimate stable version of Alpine as the base image
FROM alpine:3.17

# Install Node.js and npm
RUN apk add --no-cache nodejs npm

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Start the application
CMD ["node", "server.js"]