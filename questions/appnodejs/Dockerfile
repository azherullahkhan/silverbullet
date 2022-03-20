FROM node:lts-alpine@sha256:b2da3316acdc2bec442190a1fe10dc094e7ba4121d029cb32075ff59bb27390a

RUN apk add dumb-init

ENV NODE_ENV production

WORKDIR /usr/src/app

COPY package*.json ./

COPY --chown=node:node . .

RUN npm ci --only=production

USER node

EXPOSE 8080

CMD ["dumb-init", "node", "server.js"]