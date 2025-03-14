FROM cde/base

ENV GUM_VERSION=0.14.5
ENV GITHUB_CLI_VERSION=2.65.0

# ------- DOTNET -------

WORKDIR /installers

RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt update && \
    apt install -y dotnet-sdk-8.0=8.0.404-1 && \
    rm -rf /installers

RUN dotnet --version


# ------- NODE -------

WORKDIR /installer
RUN apt-get update && apt-get install nodejs -y && \ 
    apt-get update && apt-get install npm -y && \
    npm cache clean -f && \
    npm install -g n && \
    n 22.9.0


# ------- YARN -------

WORKDIR /installer
RUN npm install -g yarn && \
    npm install -g eslint && \
    npm install -g prettier && \
    npm install -g eslint-plugin-formatjs


# ------- AZCLI -------

WORKDIR /installers

RUN curl -sSL https://aka.ms/InstallAzureCLIDeb | bash && \
    rm -rf /installers

RUN az --version


# ------- GITHUB CLI -------

RUN curl -L -o gh.tar.gz https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.tar.gz \
    && tar -xzvf gh.tar.gz \
    && ls -a \
    && ls ./gh_${GITHUB_CLI_VERSION}_linux_amd64/bin/gh -a \
    && mv ./gh_${GITHUB_CLI_VERSION}_linux_amd64/bin/gh /usr/local/bin/gh \
    && rm gh.tar.gz \
    && rm -rf gh_${GITHUB_CLI_VERSION}_linux_amd64

RUN gh --version


# ------- SQLCMD -------

WORKDIR /installer
RUN curl -OL https://github.com/microsoft/go-sqlcmd/releases/download/v1.8.0/sqlcmd-linux-amd64.tar.bz2 && \
    tar -C /usr/local/bin -xvf sqlcmd-linux-amd64.tar.bz2

ENV PATH="$PATH:/usr/local/go/bin"

RUN sqlcmd --version


# ------- GUM -------

RUN curl -L -o gum.tar.gz https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_Linux_x86_64.tar.gz \
    && tar -xzvf gum.tar.gz \
    && mv ./gum_${GUM_VERSION}_Linux_x86_64/gum /usr/local/bin/gum \
    && rm gum.tar.gz \
    && rm -rf gum_${GUM_VERSION}_Linux_x86_64

RUN gum --version


# ------- RUN -------

COPY root/ /root/
COPY scripts/ /scripts/

RUN nvim --headless "+Lazy! sync" +qall
RUN nvim --headless "+MasonInstall --force --all" +qall

RUN chmod +x /scripts/entrypoint.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
