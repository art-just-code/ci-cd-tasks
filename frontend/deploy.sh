#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
sudo docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
sudo docker network create -d bridge sausage_network || true # пробуем создать сеть, если не получилось - прокидывает true, чтобы скрипт не упал
sudo docker rm -f sausage-frontend || true
sudo docker run -d --name sausage-frontend \
    -p 80:80 \
    -v "/home/student/default.conf:/etc/nginx/conf.d/default.conf" \
    --restart=on-failure:10 \
    --restart=always \
    --network=sausage_network \
    "${CI_REGISTRY_IMAGE}"/sausage-frontend:${VERSION}