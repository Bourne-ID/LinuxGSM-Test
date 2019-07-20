FROM centos:6
LABEL maintainer="BourneID <admin@h-r-l.co.uk>, on behalf of LinuxGSM"

ENV DEBIAN_FRONTEND noninteractive

RUN yum install -y epel-release && \
    yum install -y \
      curl \
      findutils \
      procps \
      sudo \
      unzip \
      wget && \
      yum clean all

RUN groupadd -r lgsm --gid=1337 && useradd -m -r -g lgsm --uid=1337 lgsm
RUN echo "lgsm ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN mkdir /linuxgsm && chown lgsm:lgsm /linuxgsm
USER lgsm
WORKDIR /linuxgsm

RUN wget https://linuxgsm.com/dl/linuxgsm.sh && chmod +x linuxgsm.sh

#  Docker Build working folder must me the /docker to pick up this global file
COPY runtests.sh /linuxgsm/

ENTRYPOINT ["/linuxgsm/runtests.sh"]