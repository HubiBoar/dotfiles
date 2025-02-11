#https://medium.com/@ls12styler/docker-as-an-integrated-development-environment-95bc9b01d2c1
FROM amd64/ubuntu:22.04

# ------- UPDATE -------

RUN apt-get -y update \
    && apt-get -qy full-upgrade


# ------- STOW -------

RUN apt-get install -y stow


# ------- ZSH -------

RUN apt-get install -y zsh \
    && chsh -s $(which zsh)


# ------- XCLIP -------

RUN apt-get install -y xclip


# ------- GIT -------

RUN apt-get install -y git


# ------- POWERLEVEL -------

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k /root/powerlevel10k


# ------- ZSH-AUTOSUGGESTIONS -------

RUN git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions /root/.zsh/zsh-autosuggestions
    
RUN apt-get update --fix-missing

RUN apt-get install -y \
    curl \
    inetutils-ping \
    gh \
    unzip \
    wget \
    iproute2 \
    jq


# ------- DOCKER -------

RUN curl -sSL https://get.docker.com/ | bash


# ------- LF -------

WORKDIR /installers/lf
RUN curl -LO https://github.com/gokcehan/lf/releases/download/r32/lf-linux-amd64.tar.gz && \
    tar xvf lf-linux-amd64.tar.gz && \
    chmod +x lf && \
    mv lf /usr/bin && \
    rm -rf /installers/lf


# ------- NVIM -------

WORKDIR /installers/nvim
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz && \
    rm -rf /opt/nvim && \
    tar -C /opt -xzf nvim-linux64.tar.gz && \
    rm -rf /installers/nvim

ENV PATH="$PATH:/opt/nvim-linux64/bin"


# ------- RIPGREP FOR TELESCOPE -------

WORKDIR /installers/ripgrep
RUN curl -LO 'https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb' && \
    dpkg -i ripgrep_14.1.0-1_amd64.deb && \
    apt-get install -f && \
    rm -rf /installers/ripgrep


# ------- FD-FIN FOR TELESCOPE -------

RUN apt install fd-find -y


# ------- TMUX -------

WORKDIR /installers/tmux
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
    rm -rf /installers/tmux

RUN git clone --depth=1 https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm
