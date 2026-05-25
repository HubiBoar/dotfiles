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
    less \
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

# ------- Copy Config -------

USER root

COPY --chown=${DEV_UID}:${DEV_GID} base/build/.zshrc /home/${DEV_USER}/.zshrc
COPY --chown=${DEV_UID}:${DEV_GID} base/build/.gitconfig /home/${DEV_USER}/.gitconfig
COPY --chown=${DEV_UID}:${DEV_GID} base/build/.p10k.zsh /home/${DEV_USER}/.p10k.zsh

RUN zsh -c '/home/${DEV_USER}/powerlevel10k/gitstatus/install'

# ------ Language Server Protocol -----

# ------ LUA -----

ARG LUA_LANGUAGE_SERVER_VERSION="3.18.2"
ARG LUA_LANGUAGE_SERVER_SHA256="ca71415dd19f19e30aaa35a4915aefca9fdb5fec31b98331cc3d77f778d539c5"

RUN mkdir -p /opt/lua-language-server && \
    curl -fsSL \
      "https://github.com/LuaLS/lua-language-server/releases/download/${LUA_LANGUAGE_SERVER_VERSION}/lua-language-server-${LUA_LANGUAGE_SERVER_VERSION}-linux-x64.tar.gz" \
      -o /tmp/lua-language-server.tar.gz && \
    echo "${LUA_LANGUAGE_SERVER_SHA256}  /tmp/lua-language-server.tar.gz" | sha256sum -c - && \
    tar -xzf /tmp/lua-language-server.tar.gz \
      -C /opt/lua-language-server && \
    ln -sf /opt/lua-language-server/bin/lua-language-server \
      /usr/local/bin/lua-language-server && \
    rm -f /tmp/lua-language-server.tar.gz


# ------- NVIM PLUGINS -------

COPY base/build/scripts/install-nvim-plugin /usr/local/bin/install-nvim-plugin
RUN chmod 755 /usr/local/bin/install-nvim-plugin

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

# ------- Treesitter -----
RUN install-nvim-plugin "nvim-treesitter/nvim-treesitter-textobjects" "0f051e9813a36481f48ca1f833897210dbcfffde" treesitter-text-object
RUN install-nvim-plugin "nvim-treesitter/nvim-treesitter" "42fc28ba918343ebfd5565147a42a26580579482" treesitter

# ------- LSP -----
RUN install-nvim-plugin "neovim/nvim-lspconfig" "a182334ba933e58240c2c45e6ae2d9c7ae313e00" lsp-config
RUN install-nvim-plugin "Issafalcon/lsp-overloads.nvim" "7d766bfccbff2ab0be8089ea4d1493089f67a408" lsp-overloads

# ------- Tokyonight -----
RUN install-nvim-plugin "folke/tokyonight.nvim" "057ef5d260c1931f1dffd0f052c685dcd14100a3" tokyonight.nvim 

# ------- CamelCaseMotion -----
RUN install-nvim-plugin "bkad/CamelCaseMotion" "de439d7c06cffd0839a29045a103fe4b44b15cdc" CamelCaseMotion

# ------- Completions -----
RUN install-nvim-plugin "hrsh7th/nvim-cmp" "b5311ab3ed9c846b585c0c15b7559be131ec4be9" nvim-cmp
RUN install-nvim-plugin "hrsh7th/cmp-nvim-lsp" "a8912b88ce488f411177fc8aed358b04dc246d7b" cmp-nvim-lsp

# ------ TELESCOPE ----
RUN install-nvim-plugin "nvim-lua/plenary.nvim" "857c5ac632080dba10aae49dba902ce3abf91b35" plenary
RUN install-nvim-plugin "nvim-telescope/telescope.nvim" "6312868392331c9c0f22725041f1ec2bef57c751" telescope
#RUN install-nvim-plugin "nvim-telescope/telescope-ui-select.nvim" "6e51d7da30bd139a6950adf2a47fda6df9fa06d2" telescope-ui

# ------ OIL ----
RUN install-nvim-plugin "nvim-tree/nvim-web-devicons" "1fb58cca9aebbc4fd32b086cb413548ce132c127" devicons
RUN install-nvim-plugin "stevearc/oil.nvim" "08c2bce8b00fd780fb7999dbffdf7cd174e896fb" oil


SHELL ["/bin/zsh", "-c"]
ENTRYPOINT ["/bin/zsh"]
