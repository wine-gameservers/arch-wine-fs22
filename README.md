# Farming Simulator 22 Docker Server

Dedicated Farming Simulator 22 server running inside a docker image based on ArchLinux. 
This project is hosted at https://github.com/wine-gameservers/arch-wine-fs22/

## Table of contents
<!-- vim-markdown-toc GFM -->
* [Motivation](#motivation)
* [Getting Started](#getting-started)
	* [Hardware Requirements](#hardware-requirements)
	* [Software Requirements](#software-requirements)
		* [Linux Distribution](#linux-distribution)
		* [Server License](#server-license)
		* [VNC Client](#vnc-client)
* [Deployment](#deployment)
	* [Deploying with docker-compose](#docker-compose)
	* [Deploying with docker run](#docker-run)
* [Installation](#installation)
	* [Initial installation](#initial-installation)
		* [Downloading the dedicated server](#downloading-the-dedicated-server)
		* [Preparing the needed directories on the host machine](#preparing-the-needed-directories-on-the-host-machine)
		* [Unpack and move the installer](#unpack-and-move-the-installer)
		* [Starting the container](#starting-the-container)
		* [Connecting to the VNC Server](#connecting-to-the-vnc-Server)
	* [Server Installation](#server-installation)
		* [Running the installation](#running-the-installation)
		* [Starting the admin portal](#starting-the-admin-portal)
* [Environment variables](#environment-variables)
<!-- vim-markdown-toc -->

# Motivation

GIANTS Software encourages its customers to consider renting a server from one of their verified partners, as it helps protect their business and maintain close relationships with these partners. Unfortunately, they do not allow third parties to host servers in order to support their partner network effectively.

For customers who prefer running personal servers, there is a requirement to purchase all the game content (game, DLC, packs) twice. This means obtaining one license for the player and another license specifically for the server.

While renting a server remains a viable option for certain players, it has become increasingly common for game developers to provide free-to-use server tools. Regrettably, the server tools provided by GIANTS Software are considered outdated and inefficient. As a result, users are compelled to set up an entire Windows environment. However, with our project, we have overcome this limitation by enabling users to deploy servers within a lightweight Docker environment, eliminating the need for a Windows setup.

# Getting Started

Please note that this may not cover every possible scenario, particularly for NAS (synology) users. In such cases, you may need to utilize the provided admin console to configure the necessary directories and user permissions. If you encounter any issues while attempting to run the program, kindly refrain from sending me private messages. Instead, we recommend seeking assistance on our Discord server, where you can find additional support and guidance. [invite link to our Discord server](https://discord.gg/Ejz2MaXSNb). 

## Hardware Requirements

Intel: Haswell or newer (Intel Celeron specially from older generations are not recommended)
AMD: Zen1 or newer

- Server for 2-4 players (without DLCs) 2.4 GHz (min. 3 Cores), 4 GB RAM
- Server for 5-10 players (with DLCs) 2.8 GHz (min. 3 Cores), 8 GB RAM
- Server for up to 16 players (with all DLCs) 3.2 GHz (min. 4 Cores), 12 GB RAM

*** Storage depends on installed dlc + mods ***

## Software Requirements

### Linux Distribution

Please refer to your linux distribution on how to install docker and docker-compose, the image only runs on docker suppported operating systems using the x86_64 / amd64 architecture, arm/apple is not supported.

### Server License

GIANTS Software ships the game with a dedicated server tool this means you can only run a server if you purchase an additional license from the Giants. You cannot host and play on a server with the same license, this means you need to buy everything twice in order to run the server and play on it. The steam version of the game is not supported to run as server inside docker, but you can use it to play on the server.

For the full game + all dlc you will need:

- [Farming Simulator 22 Premium Edition(https://www.farming-simulator.com/buy-now.php?lang=en&country=nl&platform=pcdigital)

** Don't get confused about other versions, even if you own the base game this is the cheapest option to unlock all content**

### VNC Client

The first time after the docker container is started you need to go trough initial installation of the game + dlc using a VNC Client, an example is VNC® Viewer.

- [VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/)

## Deployment

The key difference between docker run versus docker-compose is that docker run is entirely command line based, while docker-compose reads configuration data from a YAML file, if you are not sure what to use I would suggest to go for docker-compose.

### Docker compose
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
      - PGID=<PGID from user>
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

### Docker run
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
    -e PGID=<PGID from user> \
    toetje585/arch-wine-fs22
```
# Installation

## Initial installation

Before we attempt to start the docker container we need to go trough the initial configuration, most games offer standalone server binaries however for the Farming Simulator this is not the case. The files needed are inside the digital download, so in order to get them we need to dowload the full game and all DLC from the [Download Portal](https://eshop.giants-software.com/downloads.php).

We go into more detail below, but be reassured the installation is only once. If the compose file is configured correctly you won't lose the installation or configuration files even if you remove or purge the docker image/container. 

## Downloading the dedicated server

If you purchased the game or already have a product key you can download the game/dlc on the host machine from the [Download Portal](https://eshop.giants-software.com/downloads.php)

- Farming Simulator 22 (ZIP Archive) 

The DLC files are often just an .exe executable you can download them, we move them into the right place later on.

## Preparing the needed directories on the host machine

Because we would not like to lose the installation if we remove/update the docker container we need to configure some directories on the host side. I usually like to place them in /opt, ofcourse you can use any other mount point to your liking.

`$sudo mkdir -p /opt/fs22/{config,game,installer/dlc}`

We still need to make sure our docker container is able to write/read to this directory, we do so by running the below command to make sure the user account configured in the compose file PUID/PGID has the appropriate permission to acces them.

`$sudo chown -R myuser:mygroup /opt/fs22`

If you still need to add the required PUID/PGID to the docker-compose/run file you can find out the appropriate vallues using the linux [id](https://man7.org/linux/man-pages/man1/id.1.html) command.

`$id username`

```yaml
          - PUID=<UID from user>
          - PGID=<PGID from user>
```

## Unpack and move the installer

You should now unpack the installer and place the unzipped files inside the */your/path/installer* directory, all dlc should be placed in the */your/path/installer/dlc* directory. If we start the docker container those directories will be mapped inside the container hence making them available for installation.

*Note: Please remember the above location depends on the docker-compose mount location.*

```
- /your/path/installer:/opt/fs22/installer
- /your/path/config:/opt/fs22/config
- /your/path/game:/opt/fs22/game
```

## Starting the container

Now that we have configured the host directories and our compose file we should be able to start the container.

`$docker-compose up -d`

*Tip: You can use `$docker ps` to see if the container started correctly.

## Connecting to the VNC Server

Using VNC Viewer you can connect to the VNC Server by connecting to ip:5900, this should open up a full desktop environment here we can run the installation of the dedicated server.

# Server Installation

## Running the installation

Open up the terminal, and run the below command.

`$./setup_giants.sh`

This should run the installer, complete the installation. After the installation is completed we can start the server by using the below command.

## Starting the admin portal

`$./start_webserver.sh`

We don't have a browser inside the VNC Desktop, check if the server is working by going to ip:8080 on a other machine!

# Environment variables

Getting the PUID and GUID is explained [here](https://man7.org/linux/man-pages/man1/id.1.html).

| Name | Default | Purpose |
|----------|----------|-------|
| `VNC_PASSWORD` || Password for connecting using the vnc client |
| `WEB_USERNAME` | `admin` | Username for admin portal at :8080 |
| `SERVER_NAME` || Servername that will be shown in the server browser |
| `SERVER_PORT` | `10823` | Default: 10823, port that the server will listen on |
| `SERVER_PASSWORD` || The game join password |
| `SERVER_ADMIN` || The server ingame admin password |
| `SERVER_REGION` | `en` | en, de, jp, pl, cz, fr, es, ru, it, pt, hu, nl, cs, ct, br, tr, ro, kr, ea, da, fi, no, sv, fc |
| `SERVER_PLAYERS` | `16` | Default: 16, amount of players allowed on the server |
| `SERVER_MAP` | `MapUS` | Default: MapUS (Elmcreek), other official maps are: MapFR (Haut-Beyleron), MapAlpine (Erlengrat) |
| `SERVER_DIFFICULTY` | `3` | Default: 3, start from scratch |
| `SERVER_PAUSE` | `2` | Default: 2, pause the server if no players are connected 1, never pause the server |
| `SERVER_SAVE_INTERVAL` | `180.000000` | Default: 180.000000, in seconds.|
| `SERVER_STATS_INTERVAL` | `31536000` | Default: 120.000000|
| `SERVER_CROSSPLAY` | `true/false` | Default: true |
| `PUID` || PUID of username used on the local machine |
| `GUID` || GUID of username used on the local machine |

# Discord

Need support or like to contribute towards our community you can try to join our Discord server.

https://discord.gg/Ejz2MaXSNb

# Legal disclaimer
This Docker container is not endorsed by, directly affiliated with, maintained, authorized, or sponsored by [Giants Software](https://giants-software.com) and [Farming Simulator 22](https://farming-simulator.com/). The logo [Farming Simulator 22](https://giants-software.com) are © 2023 Giants Software.
