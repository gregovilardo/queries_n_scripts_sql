#!/bin/bash

# En algunas distros puede que necesiten llamar a docker con sudo
IP=$(docker inspect --format  '{{ .NetworkSettings.IPAddress }}' mysql-labs)

mysql --host $IP -u root -p
