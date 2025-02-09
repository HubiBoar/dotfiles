FROM devdocker/base

# dotnet

WORKDIR /installer
RUN sh /scripts/dotnet.sh && rm -rf /installer

# azcli

WORKDIR /installer
RUN sh /scripts/azcli.sh && rm -rf /installer

# node

WORKDIR /installer
RUN sh /scripts/node.sh && rm -rf /installer

# yarn

WORKDIR /installer
RUN sh /scripts/node-yarn.sh && rm -rf /installer
