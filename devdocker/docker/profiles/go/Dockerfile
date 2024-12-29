# syntax = edrevo/dockerfile-plus

INCLUDE+ ./profiles/base/Dockerfile

COPY ./dotfiles/* /dotfiles/*

# go

WORKDIR /installer
RUN sh /scripts/go.sh && rm -rf /installer
