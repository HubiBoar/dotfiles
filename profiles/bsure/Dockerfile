FROM cde/base

ENV GITHUB_CLI_VERSION=2.65.0

# ------- DOTNET -------

WORKDIR /installers

RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt update && \
    apt install -y dotnet-sdk-9.0=9.0.203-1 && \
    apt install -y dotnet-sdk-8.0=8.0.404-1 && \
    rm -rf /installers

RUN dotnet --version


# ------- NODE -------

WORKDIR /installer
RUN apt-get update && apt-get install nodejs -y && \ 
    apt-get update && apt-get install npm -y


# ------- AZCLI -------

WORKDIR /installers

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    apt-get update && \
    apt-get install azure-cli=2.72.0-1~jammy -y --allow-downgrades && \
    rm -rf /installers

RUN az --version


# ------- BICEP -------

RUN az bicep install


# ------- AZURE FUNC -------

RUN wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs 2>/dev/null)-prod $(lsb_release -cs 2>/dev/null) main" > /etc/apt/sources.list.d/dotnetdev.list' \
    && apt-get update \
    && apt-get install azure-functions-core-tools-4


# ------- GITHUB CLI -------

RUN curl -L -o gh.tar.gz https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.tar.gz \
    && tar -xzvf gh.tar.gz \
    && ls -a \
    && ls ./gh_${GITHUB_CLI_VERSION}_linux_amd64/bin/gh -a \
    && mv ./gh_${GITHUB_CLI_VERSION}_linux_amd64/bin/gh /usr/local/bin/gh \
    && rm gh.tar.gz \
    && rm -rf gh_${GITHUB_CLI_VERSION}_linux_amd64

RUN gh --version

# ------- NVIM PLUGINS --------

RUN mkdir -p /root/.config/nvim/pack/plugins/start
RUN mkdir -p /root/.config/nvim/pack/plugins/opt

# ---- PLENARY ----

WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/nvim-lua/plenary.nvim && \
    cd plenary.nvim && \
    git fetch origin 857c5ac632080dba10aae49dba902ce3abf91b35 && \
    git checkout 857c5ac632080dba10aae49dba902ce3abf91b35

# ---- TELESCOPE -----

WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/nvim-telescope/telescope.nvim && \
    cd telescope.nvim && \
    git fetch origin 6312868392331c9c0f22725041f1ec2bef57c751 && \
    git checkout 6312868392331c9c0f22725041f1ec2bef57c751


# ---- TELESCOPE UI ----

WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/nvim-telescope/telescope-ui-select.nvim && \
    cd telescope-ui-select.nvim && \
    git fetch origin 6e51d7da30bd139a6950adf2a47fda6df9fa06d2 && \
    git checkout 6e51d7da30bd139a6950adf2a47fda6df9fa06d2

# ---- HARPOON -----

WORKDIR /root/.config/nvim/pack/plugins/start
RUN git clone --depth 1 https://github.com/ThePrimeagen/harpoon.git && \
    cd harpoon && \
    git fetch origin ed1f853847ffd04b2b61c314865665e1dadf22c7 && \
    git checkout ed1f853847ffd04b2b61c314865665e1dadf22c7

# ------- RUN -------

COPY root/ /root/

RUN nvim --headless "+Lazy! sync" +qall
RUN nvim --headless "+MasonInstall --force --all" +qall
RUN nvim --headless "+MasonInstall --force omnisharp" +qall

COPY scripts/ /scripts/

RUN git config --global url."git@github-bsureas:bsureas/".insteadOf "git@github.com:bsureas/"

RUN chmod +x /scripts/entrypoint.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
