FROM ubuntu:bionic
LABEL maintainer="Michaël Roynard <mroynard@lrde.epita.fr>"

ENV container docker
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install all pkg
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get update && apt-get dist-upgrade -y && apt-get upgrade -y
RUN apt-get install -y \
    build-essential binutils git ninja-build cmake python python3 python-pip python3-pip \
    curl wget libcurl4-openssl-dev vim tree sudo
RUN apt-get install -y \
    gcc g++ libgomp1 libpomp-dev
RUN apt-get update && apt-get upgrade -y 

# Clean
RUN apt-get autoremove -y && apt-get autoclean -y
# RUN rm -rf /var/lib/apt/lists/

# Setting up gentoo user
RUN useradd -m -d /home/gentoo gentoo && cp /root/.bashrc /root/.profile /home/gentoo
RUN mkdir -p /usr/local/gentoo
WORKDIR /usr/local
RUN chown gentoo:gentoo gentoo
WORKDIR /home/gentoo
RUN su gentoo -c "wget https://gitweb.gentoo.org/repo/proj/prefix.git/plain/scripts/bootstrap-prefix.sh && chmod +x bootstrap-prefix.sh"
RUN su gentoo -c "/home/gentoo/bootstrap-prefix.sh /usr/local/gentoo noninteractive"

RUN echo y | pip install -U pip six wheel setuptools
RUN echo y | pip3 install -U pip six wheel setuptools

WORKDIR /workspace

CMD ["/bin/bash"]
