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

# ------- NVIM -------

# ------ Treesitter ----
ARG TREE_SITTER_VERSION="v0.26.9"
ARG TREE_SITTER_SHA256="0ea5daaef79145fe73786f0e3cdc43b62b22ddb36f7f6676c9f8bb72434d78e9"

RUN set -eux; \
    curl -fsSL \
      "https://github.com/tree-sitter/tree-sitter/releases/download/${TREE_SITTER_VERSION}/tree-sitter-cli-linux-x64.zip" \
      -o /tmp/tree-sitter.zip; \
    echo "${TREE_SITTER_SHA256}  /tmp/tree-sitter.zip" | sha256sum -c -; \
    unzip -q /tmp/tree-sitter.zip -d /tmp/tree-sitter-cli; \
    install -m 0755 /tmp/tree-sitter-cli/tree-sitter /usr/local/bin/tree-sitter; \
    rm -rf /tmp/tree-sitter.zip /tmp/tree-sitter-cli; \
    tree-sitter --version

# ------ NODE -----

ARG NODE_VERSION="24.15.0"
ARG NODE_DISTRO="linux-x64"
ARG NODE_DIR="node-v${NODE_VERSION}-${NODE_DISTRO}"

WORKDIR /installers/node

RUN curl -fsSL -o node.tar.xz \
      "https://nodejs.org/dist/v${NODE_VERSION}/${NODE_DIR}.tar.xz" \
    && tar -xJf node.tar.xz \
    && mv "${NODE_DIR}" "/usr/local/node-v${NODE_VERSION}" \
    && rm -rf /installers/node

ENV PATH="/usr/local/node-v${NODE_VERSION}/bin:$PATH"

RUN node --version && npm --version

# ------ Language Server Protocol -----

# ------ YAML LSP -----

ARG YAML_LANGUAGE_SERVER_VERSION="1.14.0"

RUN npm install -g yaml-language-server@${YAML_LANGUAGE_SERVER_VERSION} \
    && command -v yaml-language-server \
    && npm list -g --depth=0 yaml-language-server \
    && npm cache clean --force

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

# ------ Roslyn ----

RUN pacman -S --noconfirm --needed \
      ca-certificates \
      dotnet-sdk=10.0.4.sdk104-1

#TODO: bicep LSP, ts LSP, html LSP
#TODO: npm, azcli, bicep, github cli

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

RUN echo 'export PATH="$PATH:$HOME/.dotnet/tools"' >> "/home/${DEV_USER}/.zshrc"

ARG ROSLYN_LANGUAGE_SERVER_VERSION="5.8.0-1.26266.2"

RUN dotnet tool install \
      --global \
      roslyn-language-server \
      --version "${ROSLYN_LANGUAGE_SERVER_VERSION}"

USER root

# ------ BICEP -----
ARG BICEP_LANGUAGE_SERVER_VERSION="v0.43.8"

RUN mkdir -p /opt/bicep-langserver && \
    curl -fsSL \
      "https://github.com/Azure/bicep/releases/download/${BICEP_LANGUAGE_SERVER_VERSION}/bicep-langserver.zip" \
      -o /tmp/bicep-langserver.zip && \
    unzip -q /tmp/bicep-langserver.zip -d /opt/bicep-langserver && \
    rm -f /tmp/bicep-langserver.zip && \
    test -f /opt/bicep-langserver/Bicep.LangServer.dll

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

RUN zsh -c '/home/${DEV_USER}/powerlevel10k/gitstatus/install'

RUN mkdir -p /home/${DEV_USER}/.local/share/nvim

SHELL ["/bin/zsh", "-c"]
ENTRYPOINT ["/bin/zsh"]


#COPY base/build/scripts/install-nvim-plugin /usr/local/bin/install-nvim-plugin
#RUN chmod 755 /usr/local/bin/install-nvim-plugin

# ------- Treesitter -----
#RUN install-nvim-plugin "nvim-treesitter/nvim-treesitter-textobjects" "851e865342e5a4cb1ae23d31caf6e991e1c99f1e" treesitter-text-object
#RUN install-nvim-plugin "nvim-treesitter/nvim-treesitter" "4916d6592ede8c07973490d9322f187e07dfefac" treesitter

# ------- LSP -----
#RUN install-nvim-plugin "neovim/nvim-lspconfig" "a182334ba933e58240c2c45e6ae2d9c7ae313e00" lsp-config
#RUN install-nvim-plugin "Issafalcon/lsp-overloads.nvim" "7d766bfccbff2ab0be8089ea4d1493089f67a408" lsp-overloads

# ------- Tokyonight -----
#RUN install-nvim-plugin "folke/tokyonight.nvim" "057ef5d260c1931f1dffd0f052c685dcd14100a3" tokyonight.nvim 

# ------- CamelCaseMotion -----
#RUN install-nvim-plugin "bkad/CamelCaseMotion" "de439d7c06cffd0839a29045a103fe4b44b15cdc" CamelCaseMotion

# ------- Completions -----
#RUN install-nvim-plugin "hrsh7th/nvim-cmp" "b5311ab3ed9c846b585c0c15b7559be131ec4be9" nvim-cmp
#RUN install-nvim-plugin "hrsh7th/cmp-nvim-lsp" "a8912b88ce488f411177fc8aed358b04dc246d7b" cmp-nvim-lsp

# ------ TELESCOPE ----
#RUN install-nvim-plugin "nvim-lua/plenary.nvim" "74b06c6c75e4eeb3108ec01852001636d85a932b" plenary
#RUN install-nvim-plugin "nvim-telescope/telescope.nvim" "7d324792b7943e4aa16ad007212e6acc6f9fe335" telescope
#RUN install-nvim-plugin "nvim-telescope/telescope-ui-select.nvim" "6e51d7da30bd139a6950adf2a47fda6df9fa06d2" telescope-ui

# ------ OIL ----
#RUN install-nvim-plugin "nvim-tree/nvim-web-devicons" "1fb58cca9aebbc4fd32b086cb413548ce132c127" devicons
#RUN install-nvim-plugin "stevearc/oil.nvim" "08c2bce8b00fd780fb7999dbffdf7cd174e896fb" oil


SHELL ["/bin/zsh", "-c"]
ENTRYPOINT ["/bin/zsh"]
