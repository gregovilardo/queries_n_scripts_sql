!#bin/bash

sudo docker -d \
--name grego \
-v .:/parcial \
-e MYSQL_ROOT_PASSWORD=admin mysql:8.0


