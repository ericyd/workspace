#!/bin/bash

USER=vagrant

sudo apt-get update

sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    unzip \
    git \
    ncdu \
    gcc \
    g++ \
    make \
    libpq-dev \
    pinentry-tty

# Use nicer pinentry for GPG
if [ "$(readlink -e /usr/bin/pinentry)" != "/usr/bin/pinentry-tty" ]; then
    sudo rm /usr/bin/pinentry
    sudo ln -s /usr/bin/pinentry-tty usr/bin/pinentry
fi

# Docker (and Compose)
# https://docs.docker.com/compose/install/
# https://docs.docker.com/desktop/install/ubuntu/
if [ -z "$(command -v docker)" ]; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get -y install \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-compose-plugin

    curl -L https://desktop.docker.com/linux/main/amd64/docker-desktop-4.11.0-amd64.deb -o docker-desktop-4.11.0-amd64.deb
    sudo apt-get install ./docker-desktop-4.11.0-amd64.deb
    rm docker-desktop-4.11.0-amd64.deb

    # configure permissions
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
fi

# AWS CLI
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
if [ -z "$(command -v aws)" ]; then
    curl -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install --update
    rm -rf ./aws ./awscliv2.zip
fi

# AWS VPN client
# https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-linux.html#client-vpn-connect-linux-install
if [ -z "$(command -v awsvpnclient)" ]; then
    echo "deb [arch=amd64] https://d20adtppz83p9s.cloudfront.net/GTK/latest/debian-repo ubuntu-20.04 main" | sudo tee /etc/apt/sources.list.d/aws-vpn-client.list
    sudo apt-get update
    sudo apt-get install -y awsvpnclient
fi

# Expand File Watchers so VSCode can breathe
# https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
if ! grep -q "fs.inotify.max_user_watches=524288" "/etc/sysctl.conf" ; then
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
fi

# Node
# https://github.com/nodejs/help/wiki/Installation
if [ -z "$(command -v node)" ]; then
    mkdir -p /usr/local/lib/nodejs
    NODE_VERSION=v20.17.0
    DISTRO=linux-x64
    curl -L "https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-$DISTRO.tar.xz" -o "node-$NODE_VERSION-$DISTRO.tar.xz"
    tar -xJvf node-$NODE_VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs
    rm "node-$NODE_VERSION-$DISTRO.tar.xz"
    # not clear if editing the PATH properly persists into the VM; symlinking is a sure thing
    sudo ln -s /usr/local/lib/nodejs/node-$NODE_VERSION-$DISTRO/bin/node /usr/bin/node
    sudo ln -s /usr/local/lib/nodejs/node-$NODE_VERSION-$DISTRO/bin/npm /usr/bin/npm
    sudo ln -s /usr/local/lib/nodejs/node-$NODE_VERSION-$DISTRO/bin/npx /usr/bin/npx
fi

# Postgres
# from https://www.postgresql.org/download/linux/ubuntu/
# Even though Docker does the heavy lifting, some postgres utilities are very convenient for Node dependencies
if [ -z "$(command -v psql)" ]; then
    POSTGRES_VERION=12
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt-get update
    sudo apt-get -y install \
        postgresql-$POSTGRES_VERION \
        postgresql-client-$POSTGRES_VERION \
        libpq-dev
fi

# Set default shell - /bin/sh links to dash by default???
sudo usermod --shell /bin/bash $USER
sudo rm /bin/sh
sudo ln /bin/bash /bin/sh

# Bash Git completions
[ -z "$(grep "bash-completion/completions/git" ~/.bashrc)" ] && echo ". /usr/share/bash-completion/completions/git" >> ~/.bashrc

# If using GPG commit signing, this saves a lot of headache by extending the amount of time your GPG password lives in the cache to a year
# If not using GPG commit signing, well, doesn't hurt!
[ ! -f /home/vagrant/.gnupg/gpg-agent.conf ] || [ -z "$(grep default-cache-ttl /home/vagrant/.gnupg/gpg-agent.conf)" ] && echo "default-cache-ttl 34560000" >> /home/vagrant/.gnupg/gpg-agent.conf
[ ! -f /home/vagrant/.gnupg/gpg-agent.conf ] || [ -z "$(grep max-cache-ttl /home/vagrant/.gnupg/gpg-agent.conf)" ] && echo "max-cache-ttl 34560000" >> /home/vagrant/.gnupg/gpg-agent.conf
