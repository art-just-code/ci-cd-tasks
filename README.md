docker - ci/cd pipline with release and deploy use by docker

Java backend + Angular frontend, postgreSQL + MongoDB databases

Сборки бэкенда и фронтенда происходят в джобах build, сборщик gcr.io/kaniko-project/executor:v1.9.0-debug
Далее тесты, для бэка добавлен -Dmaven.test.skip=true чтобы Сонар не лез в бд
Далее релиз в хранилище Gitlab Container Registry
Далее деплой из этого хранилища на вм

