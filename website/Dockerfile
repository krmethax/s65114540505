FROM node:20

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install all dependencies (รวม devDependencies)
RUN npm install

# Copy source code
COPY . .

# Expose port 3000
EXPOSE 3000

# Start in dev mode
CMD ["npm", "run", "dev"]
