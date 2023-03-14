FROM ubuntu:22.04

LABEL maintainer="Jiayi Chen"

ARG DOCKER_UID
ARG DOCKER_GID

# environment variables
ENV TZ=UTC
ENV NODE_VERSION=16.13.0
ENV PHP_VERSION=7.4
ENV NVM_DIR=/usr/local/nvm

# timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# add user ubuntu with same uid and gid
RUN groupadd -g $DOCKER_GID ubuntu
RUN useradd ubuntu -u $DOCKER_UID -g $DOCKER_GID --create-home -m -s /bin/bash
RUN adduser ubuntu www-data
WORKDIR /home/ubuntu

# update the repository sources list
# and install dependencies
# install nvm
RUN mkdir -p $NVM_DIR
RUN apt-get update \
    && apt install git curl wget lsof -y \
    && git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" \
    && cd "$NVM_DIR" \
    && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` \
    && \. "$NVM_DIR/nvm.sh"

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install PHP
RUN apt install software-properties-common apt-transport-https -y \
    && add-apt-repository ppa:ondrej/php -y \
    && apt install php$PHP_VERSION -y \
    && apt install php$PHP_VERSION-{cli,common,curl,zip,gd,mysql,xml,mbstring,json,intl,fpm} -y

# Install composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# debug tools
RUN apt-get install nmap inetutils-ping bind9-host ncat nano -y

# permissions and logs
RUN mkdir -p /run/php/
RUN mkdir -p /var/log/php-fpm/

RUN chown -R ubuntu:ubuntu /var/log/
RUN chmod -R 774 /var/log/

RUN chown -R ubuntu:ubuntu /run/php/
RUN chmod -R 774 /run/php/

# configure work user, work folder and scripts
USER ubuntu
WORKDIR /var/www/html/app

COPY --chown=ubuntu:ubuntu ./docker/app/scripts /home/ubuntu/scripts/
RUN chmod -R 774 /home/ubuntu/scripts/
ENV PATH="/home/ubuntu/scripts/:$PATH"



