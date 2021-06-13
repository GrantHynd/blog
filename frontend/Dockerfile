FROM bitnami/node:15.14.0-prod

WORKDIR /usr/app

ENV PATH=/usr/node_modules/.bin:${PATH}

COPY package.json package-lock.json ./
RUN npm install

COPY . /usr/app/

CMD ["npm", "start"]