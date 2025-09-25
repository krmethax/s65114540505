FROM node:20

WORKDIR /app

# Copy package metadata first to leverage Docker layer caching
COPY package*.json ./

# Install deps plus dev tooling like nodemon needed by npm scripts
RUN npm install --include=dev

# Copy source code
COPY . .

EXPOSE 3001

CMD ["npm", "run", "dev"]
