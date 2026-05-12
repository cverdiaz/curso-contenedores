FROM node:24 AS construccion

WORKDIR /usr/app

COPY package*.json .

RUN npm ci

COPY nest-cli.json tsconfig*.json ./
COPY src ./src

RUN npm run build


FROM node:24-alpine AS publicacion

WORKDIR /usr/app

COPY package*.json .

RUN npm ci --omit=dev

COPY --from=construccion /usr/app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main.js"]
