FROM ubuntu:14.04
LABEL maintainer="BourneID <admin@h-r-l.co.uk>, on behalf of LinuxGSM"

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
      curl \
      unzip \
      wget && \
      rm -rf /var/lib/apt/lists/*

RUN groupadd -r lgsm --gid=1337 && useradd -r -g lgsm --uid=1337 lgsm

RUN mkdir /linuxgsm && chown lgsm:lgsm /linuxgsm
USER lgsm
WORKDIR /linuxgsm

RUN wget https://linuxgsm.com/dl/linuxgsm.sh && chmod +x linuxgsm.sh

#Docker Build working folder must me the /docker to pick up this global file
COPY runtests.sh runtests.sh

ENTRYPOINT runtests.sh

