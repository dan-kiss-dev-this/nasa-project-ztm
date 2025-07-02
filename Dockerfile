FROM node:lts-alpine

# make folder for application
WORKDIR /app

# copy file from local machine into docker image . is root and destination is the /app folder in the docker image, done with a layer. the star here is to use package-lock.json
COPY package*.json ./

COPY client/package*.json client/
RUN npm run install-client --omit-dev

# install packages but only ones needed for production, note we want the node modules to be installed for this operating system of alpine linux not macos, the .dockerignore file does this, note builds vary based on machine a package on macos is not always the same as the same package on say a windows machine

COPY server/package*.json server/
RUN npm run install-server --omit-dev

# this will build the front end and go into the client folder to do it
COPY client/ client/
RUN npm run build --prefix client

COPY server/ server/

# user who runs container be a node user not root for security
USER node

# what to do when docker container starts up, we turn on the server
CMD [ "npm", "start", "--prefix", "server"]

# application is running on port 8000 so exose it
EXPOSE 8000