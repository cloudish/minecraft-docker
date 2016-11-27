FROM java:7
MAINTAINER Justin Barone https://github.com/cloudish https://hub.docker.com/u/zoltanthedestroyer/

##set up hamachi
# Set correct environment variables
ENV DOWNLOAD_PATH https://www.vpn.net/installers/logmein-hamachi_2.1.0.174-1_amd64.deb

# ...put your own build instructions here...
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get update && apt-get install -y net-tools curl rsync tmux #net-tools is nice if you need to troubleshoot hamachi
ADD $DOWNLOAD_PATH /tmp/hamachi.deb
RUN dpkg -i /tmp/hamachi.deb

VOLUME /var/lib/logmein-hamachi

ADD run-hamachi.sh /usr/local/bin/
RUN chmod +x /etc/service/hamachi/run

# Taken from Postgres Official Dockerfile.
# grab gosu for easy step-down from root
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

RUN groupadd -g 1000 minecraft && \
    useradd -g minecraft -u 1000 -r -M minecraft && \
    touch /run/first_time && \
    mkdir -p /opt/minecraft /usr/src/minecraft && \
    echo "set -g status off" > /root/.tmux.conf

COPY minecraft /usr/local/bin/
ONBUILD COPY . /usr/src/minecraft

EXPOSE 25565

ENTRYPOINT ["/usr/local/bin/minecraft"]
CMD ["run"]
