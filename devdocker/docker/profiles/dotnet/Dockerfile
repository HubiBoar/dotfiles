FROM cde/base

COPY ./dotfiles/* /dotfiles/*

# dotnet

WORKDIR /installer
RUN sh /scripts/dotnet.sh && rm -rf /installer

# azcli

WORKDIR /installer
RUN sh /scripts/azcli.sh && rm -rf /installer

RUN stow --dir="/dotfiles/" --target=$HOME --adopt -v .
