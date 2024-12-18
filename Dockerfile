FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# title
ENV TITLE=Chromium
ENV CHROME_VERSION=128.0.6613.84-1~deb12u1 

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/chromium-logo.png

RUN ssurl="https://raw.gitmirror.com/Truth1984/shell-simple/main/util.sh"; if command -v curl > /dev/null 2>&1; then curl -sSL $ssurl -o util.sh; elif command -v wget > /dev/null 2>&1; then wget -O util.sh $ssurl; else echo "Neither curl nor wget found"; exit 1; fi; chmod 777 util.sh && ./util.sh setup && \ 
u setupEX -c && echo "deb http://snapshot.debian.org/archive/debian/20241020/ bookworm main contrib non-free" | sudo tee -a /etc/apt/sources.list && u upgrade

RUN u installC socat fonts-noto-cjk chromium-common=$CHROME_VERSION chromium=$CHROME_VERSION chromium-l10n=$CHROME_VERSION && \
u cleanup && rm -rf /config/.cache

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
