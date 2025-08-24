FROM node:20

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies (รวม devDependencies สำหรับ dev mode)
RUN npm install

# Copy source code
COPY . .

# Expose port
EXPOSE 3001

# Start in dev mode
CMD ["npm", "run", "dev"]
