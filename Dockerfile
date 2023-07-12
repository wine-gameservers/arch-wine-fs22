FROM toetje585/arch-wine-vnc:latest
LABEL org.opencontainers.image.authors = "Toetje585"
LABEL org.opencontainers.image.source = "https://github.com/wine-gameservers/arch-wine-vnc"

# additional files
##################

COPY build/rootfs /

RUN chown -R nobody:nobody /home/*

# add install bash script
ADD build/install.sh /root/install.sh

# install script
##################
RUN chmod +x /root/install.sh && /bin/bash /root/install.sh

# Expose port for FS22 Webserver

EXPOSE 8080/tcp

# Expose port for the FS22 Gameserver
EXPOSE 10823/tcp
EXPOSE 10823/udp
