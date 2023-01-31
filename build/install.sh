#!/bin/bash

set -e

# needed packages

echo "[info] Installing packages currently not installed..."
pacman -Syu --noconfirm && pacman -S nginx-mainline --noconfirm

# create file with contents of here doc, note EOF is NOT quoted to allow us to expand current variable 'install_paths'
# we use escaping to prevent variable expansion for PUID and PGID, as we want these expanded at runtime of init.sh

# env vars
####

cat <<'EOF' > /tmp/envvars_heredoc

# Webserver

if [ -n "$WEB_USERNAME" ]; then
    sed -i "s/<username>admin<\/username>/<username>$WEB_USERNAME<\/username>/" /opt/fs22/xml/default_dedicatedServer.xml
fi

if [ -n "$WEB_PASSWORD" ]; then
    sed -i "s/<passphrase>webpassword<\/passphrase>/<passphrase>$WEB_PASSWORD<\/passphrase>/" /opt/fs22/xml/default_dedicatedServer.xml
fi

# Gameserver

if [ -n "$SERVER_NAME" ]; then
    sed -i "s/<game_name><\/game_name>/<game_name>$SERVER_NAME<\/game_name>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$SERVER_ADMIN" ]; then
    sed -i "s/<admin_password><\/admin_password>/<admin_password>$SERVER_ADMIN<\/admin_password>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$SERVER_PASSWORD" ]; then
    sed -i "s/<game_password><\/game_password>/<game_password>$SERVER_PASSWORD<\/game_password>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$SERVER_PLAYERS" ]; then
    sed -i "s/<max_player>12<\/max_player>/<max_player>$SERVER_PLAYERS<\/max_player>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$SERVER_PORT" ]; then
    sed -i "s/<port>10823<\/port>/<port>$SERVER_PORT<\/port>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$SERVER_REGION" ]; then
    sed -i "s/<language>en<\/language>/<language>$SERVER_REGION<\/language>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$SERVER_MAP" ]; then
    sed -i "s/<mapID>MapUS<\/mapID>/<mapID>$SERVER_MAP<\/mapID>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$SERVER_DIFFICULTY" ]; then
    sed -i "s/<difficulty>3<\/difficulty>/<difficulty>$SERVER_DIFFICULTY<\/difficulty>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$SERVER_PAUSE" ]; then
    sed -i "s/<pause_game_if_empty>2<\/pause_game_if_empty>/<pause_game_if_empty>$SERVER_PAUSE<\/pause_game_if_empty>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$SERVER_SAVE_INTERVAL" ]; then
    sed -i "s/<auto_save_interval>180.000000<\/auto_save_interval>/<auto_save_interval>$SERVER_SAVE_INTERVAL<\/auto_save_interval>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$SERVER_STATS_INTERVAL" ]; then
    sed -i "s/<stats_interval>360.000000<\/stats_interval>/<stats_interval>$SERVER_STATS_INTERVAL<\/stats_interval>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

if [ -n "$SERVER_CROSSPLAY" ]; then
    sed -i "s/<crossplay_allowed>true<\/crossplay_allowed>/<crossplay_allowed>$SERVER_CROSSPLAY<\/crossplay_allowed>/" /opt/fs22/xml/default_dedicatedServerConfig.xml
fi

EOF

# replace env vars placeholder string with contents of file (here doc)

sed -i '/# ENVVARS_PLACEHOLDER/{
    s/# ENVVARS_PLACEHOLDER//g
    r /tmp/envvars_heredoc
}' /usr/local/bin/init.sh
rm /tmp/envvars_heredoc

# Symlinks

ln -s /opt/fs22/setup_giants.sh /home/nobody/setup_giants.sh
ln -s /opt/fs22/start_webserver.sh /home/nobody/start_webserver.sh
