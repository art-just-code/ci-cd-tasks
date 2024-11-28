FROM maven:3.9.3-eclipse-temurin-20-alpine AS builder
# сделали переменную VERSION, она нам понадобится, чтобы передавать при сборке образа версию сосисочного бэкенда
ARG VERSION=${VERSION}
# копируем исходники сосисочного бэкенда в создаваемый образ
WORKDIR /usr/src/app
COPY ./src ./src
COPY *.xml ./
# копируем CA-сертификат Яндекса в образ, после команды mvn package в папке target создастся jar-файл с сервсисом сосисочного бэкенда
RUN wget -O YandexInternalRootCA.crt https://storage.yandexcloud.net/cloud-certs/CA.pem \
  && mvn package -Dversion.application=${VERSION} -Dverofapp=${VERSION} -Dmaven.test.skip=true

# шаг релиза, jre - базовый runtime для java-приложения 
FROM bellsoft/liberica-runtime-container:jre-17-slim-musl
ARG VERSION=${VERSION}
ARG JAR_FILE=target/*.jar
WORKDIR /app
COPY --from=builder /usr/src/app/YandexInternalRootCA.crt .
# подкидываем CA-сертификат Яндекса в хранилище сертификатов для Java,
# создаём пользователя jaruser,
# устанавливаем утилиту dumb-init,
RUN keytool -importcert -file YandexInternalRootCA.crt \
  -alias yandex -cacerts -storepass changeit -noprompt \
  && rm -rf YandexInternalRootCA.crt \
  && addgroup --system jaruser \
  && adduser -S -s /bin/false -G jaruser jaruser -D -H
# cоздавать домашнюю папку для сервисных пользователей в общем случае не рекомендуется по соображениям безопасности, так взломать доступ сложнее
# копируем собранный артефакт в папку /app
COPY --chown=jaruser:jaruser \
  --from=builder /usr/src/app/${JAR_FILE} ./sausage-store.jar
# директива EXPOSE не открывает порт, а лишь указывает, что приложение работает на этом порту
EXPOSE 8080
# приложение будет запускаться под пользователем jaruser
USER jaruser
# устанавливаем точку входа, вернее ту команду, которая запустится при старте контейнера
ENTRYPOINT ["java", "-jar", "-Dmyserver.bindPort=8080", "/app/sausage-store.jar"] 

# Запуск:
# export VERSION="0.0.1"
# docker build -t sausage-backend:$VERSION --build-arg VERSION=$VERSION . 
# docker run --rm -d --env-file .env -p 8080:8080 --name sausage-backend sausage-backend:0.0.1