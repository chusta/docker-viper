#!/bin/bash
[ $(id -u) -ne 0 ] && echo "run as root." && exit
docker exec -i -t viper_viper_1 viper-cli
