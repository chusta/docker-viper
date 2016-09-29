#!/bin/bash
docker build -t viper --no-cache=true . && \
docker run -d -p 8080:8080 -p 9090:9090 -v /viper:/viper --name viper viper
