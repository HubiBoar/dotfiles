#!/bin/bash


create_dotnet_session() {
    session_name=$1
    session_path=$2

    tmux new-session -d -s "$session_name" -c "$session_path" -n zsh

    tmux new-window -t "$session_name":2 -c "$session_path" -n lf "source /root/.zshrc && lf; exec zsh"
    tmux new-window -t "$session_name":3 -c "$session_path/src" -n nvim "source /root/.zshrc; dotnet build; nvim .; exec zsh" 
}

chmod +x /scripts/*.sh

source /scripts/create-session.sh

/scripts/create-default-sessions.sh

create_dotnet_session "konfik" "/home/projects/hubiboar/konfik"
create_dotnet_session "definit" "/home/projects/hubiboar/definit"
create_dotnet_session "feature-slice" "/home/projects/hubiboar/feature-slice"

/scripts/run.sh
