FROM node:20.11 AS base

WORKDIR /usr/docker-nodejs-sample

COPY package*.json ./

RUN npm ci

COPY . .


FROM node:20.11-alpine AS dev

WORKDIR /usr/docker-nodejs-sample

COPY package*.json ./

RUN npm ci

COPY --from=base /usr/docker-nodejs-sample/src ./src

CMD ["npm", "run", "dev"]



FROM node:20.11-alpine AS prod

WORKDIR /usr/docker-nodejs-sample

COPY package*.json ./

RUN npm ci --only=production

COPY --from=base /usr/docker-nodejs-sample/src ./src

EXPOSE 3000

CMD [ "node", "src/index.js"]

