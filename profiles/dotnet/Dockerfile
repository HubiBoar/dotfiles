FROM cde/base

# azcli
WORKDIR /installers

RUN curl -sSL https://aka.ms/InstallAzureCLIDeb | bash && \
    rm -rf /installers

RUN az --version

# dotnet
WORKDIR /installers

RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt update && \
    apt install -y dotnet-sdk-8.0=8.0.404-1 && \
    rm -rf /installers

RUN dotnet --version
