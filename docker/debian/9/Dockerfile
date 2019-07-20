FROM debian:9
LABEL maintainer="BourneID <admin@h-r-l.co.uk>, on behalf of LinuxGSM"

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
      curl \
      locales \
      sudo \
      unzip \
      wget && \
      rm -rf /var/lib/apt/lists/* && \
      localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN groupadd -r lgsm --gid=1337 && useradd -m -r -g lgsm --uid=1337 lgsm
RUN echo "lgsm ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir /linuxgsm && chown lgsm:lgsm /linuxgsm
USER lgsm
WORKDIR /linuxgsm

RUN wget https://linuxgsm.com/dl/linuxgsm.sh && chmod +x linuxgsm.sh

#  Docker Build working folder must me the /docker to pick up this global file
COPY runtests.sh /linuxgsm/

ENTRYPOINT ["/linuxgsm/runtests.sh"]