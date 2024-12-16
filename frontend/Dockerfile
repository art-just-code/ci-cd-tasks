FROM node:16.20.0-alpine3.18 AS builder
# в контейнере фронта создаем дирректорию /app, в нее компируем все файлы
WORKDIR /usr/src/app
# --chown=node:node
COPY . .
# сборка
RUN npm install
RUN npm run build

# NGINX step
FROM nginx:stable-alpine3.17-slim
WORKDIR /app
# копируем файлы из билдера
COPY --from=builder /usr/src/app/dist/frontend ./frontend
COPY ./default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

# docker run -d -p 8080:8080 <image-name>