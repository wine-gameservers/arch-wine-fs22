#!/bin/bash

export WINEDEBUG=-all,fixme-all
export WINEPREFIX=~/.fs22server

# Start the server

if [ -f ~/.fs22server/drive_c/Program\ Files\ \(x86\)/Farming\ Simulator\ 2022/dedicatedServer.exe ]
then
    wine ~/.fs22server/drive_c/Program\ Files\ \(x86\)/Farming\ Simulator\ 2022/dedicatedServer.exe
else
    echo "Game not installed?" && exit
fi

exit 0
