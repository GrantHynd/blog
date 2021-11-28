FROM bitnami/node:15.14.0-prod as local

RUN npm install -g serve

WORKDIR /usr/app
COPY package.json package-lock.json ./
RUN npm install
COPY . /usr/app/
CMD ["npm", "start"]

# Build optimised version of app
FROM local AS production
COPY . /usr/app/
RUN npm run build
CMD ["serve", "-s", "build"]