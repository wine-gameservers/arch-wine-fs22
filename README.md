# arch-wine-fs22

Dedicated Farming Simulator 22 server running by using Wine on ArchLinux based docker image.
This project is hosted at https://github.com/wine-gameservers/arch-wine-fs22/

# Table of contents
<!-- vim-markdown-toc GFM -->
* [Deployment](#deployment)
	* [Deploying with docker run](#docker-run)
	* [Deploying with docker-compose](#docker-compose)
<!-- vim-markdown-toc -->
# Deployment
# Docker run
```
$ docker run -d \
    --name arch-wine-fs22 \
    -p 5900:5900/tcp \
    -p 8080:8080/tcp \
    -p 9000:9000/tcp \
    -p 10823:10823/tcp \
    -p 10823:10823/udp \
    -v /etc/localtime:/etc/localtime:ro \
    -v /opt/fs22/installer:/opt/fs22/installer \
    -v /opt/fs22/config:/opt/fs22/config \
    -v /opt/fs22/game:/opt/fs22/game \
    -e VNC_PASSWORD="<your vnc password>" \
    -e WEB_USERNAME="<dedicated server portal username>" \
    -e WEB_PASSWORD="<dedicated server portal password>" \
    -e SERVER_NAME="<your server name>" \
    -e SERVER_PASSWORD="your game join password" \
    -e SERVER_ADMIN="<your server admin password>" \
    -e SERVER_PLAYERS="16" \
    -e SERVER_PORT="10823" \
    -e SERVER_REGION="en" \
    -e SERVER_MAP="MapUS" \
    -e SERVER_DIFFICULTY="3" \
    -e SERVER_PAUSE="2" \
    -e SERVER_SAVE_INTERVAL="180.000000" \
    -e SERVER_STATS_INTERVAL="31536000" \
    -e SERVER_CROSSPLAY="true" \
    -e PUID=<UID from user> \
    -e PGID=<UID from user> \
    toetje585/arch-wine-fs22
```
# Docker compose
```
version: "3.9"
services:
  arch-wine-fs22:
    image: toetje585/arch-wine-fs22:latest
    container_name: arch-wine-fs22
    environment:
      - VNC_PASSWORD=<your vnc password>
      - WEB_USERNAME=<dedicated server portal username>
      - WEB_PASSWORD=<dedicated server portal password>
      - SERVER_NAME=<your server name>
      - SERVER_PASSWORD=<your game join password>
      - SERVER_ADMIN=<your server admin password>
      - SERVER_PLAYERS=16
      - SERVER_PORT=10823
      - SERVER_REGION=en
      - SERVER_MAP=MapUS
      - SERVER_DIFFICULTY=3
      - SERVER_PAUSE=2
      - SERVER_SAVE_INTERVAL=180.000000
      - SERVER_STATS_INTERVAL=31536000
      - SERVER_CROSSPLAY=true
      - PUID=<UID from user>
      - PGID=<UID from user>
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /opt/fs22/config:/opt/fs22/config
      - /opt/fs22/game:/opt/fs22/game
      - /opt/fs22/installer:/opt/fs22/installer
    ports:
      - 5900:5900/tcp
      - 8080:8080/tcp
      - 10823:10823/tcp
      - 10823:10823/udp
    cap_add:
      - SYS_NICE
    restart: unless-stopped
```
