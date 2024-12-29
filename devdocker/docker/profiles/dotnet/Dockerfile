# syntax = edrevo/dockerfile-plus

INCLUDE+ ../base/Dockerfile

COPY ./dotfiles/* /dotfiles/*

# dotnet

WORKDIR /installer
RUN sh /scripts/dotnet.sh && rm -rf /installer

# azcli

WORKDIR /installer
RUN sh /scripts/azcli.sh && rm -rf /installer
