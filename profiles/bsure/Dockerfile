FROM cde/base

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
    apt-get update && apt-get install npm -y


# ------- AZCLI -------

WORKDIR /installers

RUN curl -sSL https://aka.ms/InstallAzureCLIDeb | bash && \
    rm -rf /installers

RUN az --version


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


# ------- RUN -------

COPY root/ /root/

RUN nvim --headless "+Lazy! sync" +qall
RUN nvim --headless "+MasonInstall --force --all" +qall
RUN nvim --headless "+MasonInstall --force omnisharp" +qall

COPY scripts/ /scripts/

RUN chmod +x /scripts/entrypoint.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
