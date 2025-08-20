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

RUN az bicep install --version v0.33.93


# ------- AZURE FUNC -------

#RUN wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
#    && dpkg -i packages-microsoft-prod.deb \
#    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs 2>/dev/null)-prod $(lsb_release -cs 2>/dev/null) main" > /etc/apt/sources.list.d/dotnetdev.list' \
#    && apt-get update \
#    && apt-get install azure-functions-core-tools-4


# ------- GITHUB CLI -------

RUN curl -L -o gh.tar.gz https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.tar.gz \
    && tar -xzvf gh.tar.gz \
    && ls -a \
    && ls ./gh_${GITHUB_CLI_VERSION}_linux_amd64/bin/gh -a \
    && mv ./gh_${GITHUB_CLI_VERSION}_linux_amd64/bin/gh /usr/local/bin/gh \
    && rm gh.tar.gz \
    && rm -rf gh_${GITHUB_CLI_VERSION}_linux_amd64

RUN gh --version


# ------- KUBE CTL ---------

RUN curl -LO https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN kubectl version --client



# ------- K3D ---------

RUN curl -Lo k3d https://github.com/k3d-io/k3d/releases/download/v5.8.3/k3d-linux-amd64 \
    && chmod +x k3d \
    && mv k3d /usr/local/bin/

RUN k3d --version



# ------- K9S ---------

RUN curl -L https://github.com/derailed/k9s/releases/download/v0.50.9/k9s_Linux_amd64.tar.gz | tar xz \
    && mv k9s /usr/local/bin/ \
    && chmod +x /usr/local/bin/k9s

RUN k9s version


# ------- ArgoCD ---------

RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v3.0.12/argocd-linux-amd64 \
    && install -m 555 argocd-linux-amd64 /usr/local/bin/argocd \
    && rm argocd-linux-amd64

RUN argocd --help



# ------- HELM ---------

RUN curl -LO https://get.helm.sh/helm-v3.17.4-linux-amd64.tar.gz \
    && tar -zxvf helm-v3.17.4-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm

RUN helm version



# ------- RUN -------

COPY root/ /root/

RUN nvim --headless "+Lazy! sync" +qall
RUN nvim --headless "+MasonInstall --force --all" +qall
RUN nvim --headless "+MasonInstall --force omnisharp" +qall

COPY scripts/ /scripts/

RUN git config --global url."git@github-bsureas:bsureas/".insteadOf "git@github.com:bsureas/"

RUN chmod +x /scripts/entrypoint.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
