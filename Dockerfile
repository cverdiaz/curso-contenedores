#Primera Etapa: Construcción(imagen Temporal)
FROM node:24 AS construccion

WORKDIR /usr/app

COPY package*.json ./

RUN npm install

COPY nest-cli.json tsconfig*.json ./
COPY src ./src

RUN npm run build

#Segunda Etapa: Publicación(imagen Final)
FROM node:24-alpine AS publicacion

WORKDIR /usr/app

COPY package*.json ./

#omito las dependencias de desarrollo, ya que no son necesarias para ejecutar la aplicación
RUN npm ci --omit=dev

#COPY etapa ruta_estapa Destino_imagen
COPY --from=construccion /usr/app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main.js"]