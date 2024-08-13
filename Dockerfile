FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# title
ENV TITLE=Chromium
ENV CHROME_VERSION=121.0.6167.139-1~deb12u1

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/chromium-logo.png 

RUN ssurl="https://raw.gitmirror.com/Truth1984/shell-simple/main/util.sh"; if command -v curl > /dev/null 2>&1; then curl -sSL $ssurl -o util.sh; elif command -v wget > /dev/null 2>&1; then wget -O util.sh $ssurl; else echo "Neither curl nor wget found"; exit 1; fi; chmod 777 util.sh && ./util.sh setup
RUN u setupEX -c
RUN u install socat fonts-noto-cjk chromium=$CHROME_VERSION chromium-l10n=$CHROME_VERSION

RUN apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
