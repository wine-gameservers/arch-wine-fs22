#!/bin/bash

export WINEDEBUG=-all,fixme-all
export WINEPREFIX=~/.fs22server
export WINEARCH=win64
export USER=nobody

# Check if the config directory is already written

if [ -d /opt/fs22/config/FarmingSimulator2022 ]
then
    echo "The host config directories are already in place!"
else
mkdir -p /opt/fs22/config/FarmingSimulator2022

fi

if [ -d ~/.fs22server/drive_c/users/$USER/Documents/My\ Games\FarmingSimulator2022 ]
then
    echo "The docker config directories are already in place!"
else
mkdir -p ~/.fs22server/drive_c/users/$USER/Documents/My\ Games

fi


if [ -d /opt/fs22/game/Farming\ Simulator\ 2022 ]
then
    echo "The host game directorie are already in place!"
else
mkdir -p /opt/fs22/game/Farming\ Simulator\ 2022

fi


if [ -d /opt/fs22/game/Farming\ Simulator\ 2022 ]
then
    ln -s /opt/fs22/game/Farming\ Simulator\ 2022 ~/.fs22server/drive_c/Program\ Files\ \(x86\)/Farming\ Simulator\ 2022
else
echo "The host game directorie are not in place can't create symlink!"

fi

if [ -d ~/.fs22server/drive_c/users/$USER/Documents/My\ Games ]
then
    ln -s /opt/fs22/config/FarmingSimulator2022 ~/.fs22server/drive_c/users/$USER/Documents/My\ Games
else
echo "The docker config directorie are not in place can't create symlink!"

fi

if [ -d ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/logs ]
then
    echo "The log directories are in place!"
else
    mkdir -p ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/logs

fi

if [ -f ~/.fs22server/drive_c/Program\ Files\ \(x86\)/Farming\ Simulator\ 2022/FarmingSimulator2022.exe ]
then
    echo "Already installed we can skip this"
else
    wine "/opt/fs22/installer/FarmingSimulator2022.exe"
fi

# Do we have a license file installed?

count=`ls -1 ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/*.dat 2>/dev/null | wc -l`
if [ $count != 0 ]
then
    echo "License files detected"
else
    wine ~/.fs22server/drive_c/Program\ Files\ \(x86\)/Farming\ Simulator\ 2022/FarmingSimulator2022.exe
fi

count=`ls -1 ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/*.dat 2>/dev/null | wc -l`
if [ $count != 0 ]
then
    echo "We have a license now!"
else
    echo "We cannot start without license files" && exit
fi

# Copy webserver config..

if [ -d ~/.fs22server/drive_c/Program\ Files\ \(x86\)/Farming\ Simulator\ 2022/ ]
then
    cp "/opt/fs22/xml/default_dedicatedServer.xml" ~/.fs22server/drive_c/Program\ Files\ \(x86\)/Farming\ Simulator\ 2022/dedicatedServer.xml
else
    echo "Game not installed?" && exit
fi

# Copy server config

if [ -d ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/ ]
then
    cp "/opt/fs22/xml/default_dedicatedServerConfig.xml" ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/dedicatedServerConfig.xml
else
    echo "Game diden't start for first time no directories?" && exit
fi

# Check config if not exist exit

if [ -f ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/dedicatedServerConfig.xml ]
then
    echo "We can run the server"
else
    echo "We are missing files?" && exit
fi

# Lets purge the logs so we won't have errors/warnings at server start...

if [ -f ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/logs/server.log ]
then
    rm ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/logs/server.log && touch ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/logs/server.log
else
    touch ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/logs/server.log
fi

if [ -f ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/logs/webserver.log ]
then
    rm ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/logs/webserver.log && touch ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/logs/webserver.log
else
    touch ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/dedicated_server/logs/webserver.log
fi

if [ -f ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/log.txt ]
then
    rm ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/log.txt && touch ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/log.txt
else
    touch ~/.fs22server/drive_c/users/$USER/Documents/My\ Games/FarmingSimulator2022/log.txt
fi

exit 0
