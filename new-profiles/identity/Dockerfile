FROM --platform=linux/amd64 archlinux/archlinux:base-devel-20260524.0.535294

ARG DEV_USER
ARG DEV_UID
ARG DEV_GID

ARG ARCH_SNAPSHOT_DATE=2026/05/24
ARG NEOVIM_VERSION=0.12.2
ARG LAZYSQL_VERSION=0.3.7
ARG POWERLEVEL10K_REF=35833ea15f14b71dbcebc7e54c104d8d56ca5268 #v1.20.0
ARG ZSH_AUTOSUGGESTIONS_REF=e52ee8ca55bcc56a17c828767a3f98f22a68d4eb #v0.7.1

USER root

# ------- PACMAN SNAPSHOT -------

RUN printf 'Server = https://archive.archlinux.org/repos/%s/$repo/os/$arch\n' "$ARCH_SNAPSHOT_DATE" > /etc/pacman.d/mirrorlist && \
    pacman -Syyu --noconfirm

# ------- CORE PACKAGES -------

RUN pacman -S --noconfirm \
    zsh \
    xclip \
    git \
    curl \
    inetutils \
    github-cli \
    zip \
    unzip \
    fzf \
    wget \
    iproute2 \
    jq \
    fd \
    ripgrep \
    tar \
    gzip \
    ca-certificates \
    && pacman -Scc --noconfirm

ENV SHELL=/bin/zsh

# ------- NVIM -------

WORKDIR /installers/nvim

RUN curl -fsSL -o nvim-linux-x86_64.tar.gz \
    "https://github.com/neovim/neovim/releases/download/v${NEOVIM_VERSION}/nvim-linux-x86_64.tar.gz" && \
    rm -rf /opt/nvim /opt/nvim-linux-x86_64 && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    rm -rf /installers/nvim

ENV PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# ------- LAZY SQL -------

WORKDIR /installers/lazysql

RUN curl -fsSL -o lazysql_Linux_x86_64.tar.gz \
    "https://github.com/jorgerojas26/lazysql/releases/download/v${LAZYSQL_VERSION}/lazysql_Linux_x86_64.tar.gz" && \
    tar xvf lazysql_Linux_x86_64.tar.gz && \
    mv lazysql /usr/local/bin/lazysql && \
    chmod +x /usr/local/bin/lazysql && \
    rm -rf /installers/lazysql

RUN lazysql --help

# ------- DEV USER -------

RUN groupadd --gid "${DEV_GID}" "${DEV_USER}" \
  && useradd \
    --uid "${DEV_UID}" \
    --gid "${DEV_GID}" \
    --create-home \
    --shell /bin/zsh \
    "${DEV_USER}"

# ------- USER PLUGINS -------

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

# ------- POWERLEVEL10K -------

RUN mkdir -p /home/${DEV_USER}/powerlevel10k && \
    curl -fsSL \
      "https://github.com/romkatv/powerlevel10k/archive/${POWERLEVEL10K_REF}.tar.gz" \
    | tar -xz --strip-components=1 -C /home/${DEV_USER}/powerlevel10k

# ------- ZSH-AUTOSUGGESTIONS -------

RUN mkdir -p /home/${DEV_USER}/.zsh/zsh-autosuggestions && \
    curl -fsSL \
      "https://github.com/zsh-users/zsh-autosuggestions/archive/${ZSH_AUTOSUGGESTIONS_REF}.tar.gz" \
    | tar -xz --strip-components=1 -C /home/${DEV_USER}/.zsh/zsh-autosuggestions

SHELL ["/bin/zsh", "-c"]
