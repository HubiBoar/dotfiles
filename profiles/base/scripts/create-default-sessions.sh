#!/bin/bash

source /scripts/create-session.sh

create_session "config" "/root/.config"
create_session "dotfiles" "/home/dotfiles"
create_session "desktop" "/desktop"
create_session "projects" "/home/projects"
