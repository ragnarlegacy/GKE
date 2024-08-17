FROM --platform=${BUILDPLATFORM} node:14

# Create app directory
WORKDIR /app

# Install app dependencies
COPY package*.json /app

RUN npm install \
    npm install express

# Bundle app source
COPY . /app

EXPOSE 4000
CMD [ "node", "index.js" ]