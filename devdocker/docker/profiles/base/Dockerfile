#https://medium.com/@ls12styler/docker-as-an-integrated-development-environment-95bc9b01d2c1
FROM amd64/ubuntu:22.04

COPY ./dotfiles /dotfiles
COPY ./scripts /scripts

#apt-get update
RUN apt-get -y update \
    && apt-get -qy full-upgrade

#zsh
RUN apt-get install -y zsh \
    && chsh -s $(which zsh)

#xclip
RUN apt-get install -y xclip

#git
RUN apt-get install -y git \
    && git clone --depth=1 https://github.com/romkatv/powerlevel10k /root/powerlevel10k \
    && git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions /root/.zsh/zsh-autosuggestions
    
#stow
RUN apt-get install -y stow

RUN apt-get update --fix-missing

RUN apt-get install -y \
    curl \
    inetutils-ping \
    gh \
    unzip \
    wget \
    iproute2 \
    jq

#docker
RUN curl -sSL https://get.docker.com/ | bash

#LF
WORKDIR /root/installers/lf
RUN curl -LO https://github.com/gokcehan/lf/releases/download/r32/lf-linux-amd64.tar.gz && \
    tar xvf lf-linux-amd64.tar.gz && \
    chmod +x lf && \
    mv lf /usr/bin && \
    rm -rf /root/installers/lf

#NVIM
WORKDIR /root/installers/nvim
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz && \
    rm -rf /opt/nvim && \
    tar -C /opt -xzf nvim-linux64.tar.gz && \
    rm -rf /root/installers/nvim

#ripgrep for telescope
WORKDIR /root/installers/ripgrep
RUN curl -LO 'https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb' && \
    dpkg -i ripgrep_14.1.0-1_amd64.deb && \
    apt-get install -f && \
    rm -rf /root/installers/ripgrep

#TMUX
WORKDIR /root/installers/tmux
RUN apt-get install -y \
    automake \
    build-essential \
    pkg-config \
    libevent-dev \
    libncurses5-dev \
    bison

RUN curl -LO https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz && \
    tar -C . -xzf tmux-3.4.tar.gz && \
    cd tmux-3.4 && \
    ./configure && \
    make && \
    make install && \
    rm -rf /root/installers/tmux

RUN git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
