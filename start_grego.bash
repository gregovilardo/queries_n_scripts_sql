#!/bin/sh
IP=$(docker inspect --format  '{{ .NetworkSettings.IPAddress }}' grego)
echo $IP
sudo docker start grego
sudo docker exec -it grego bash -c "mysql -h $IP -padmin"
