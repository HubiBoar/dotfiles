#!/bin/bash

create_nordic_session() {
    session_name=$1
    session_path=$2

    tmux new-session -d -s "$session_name" -c "$session_path" -n zsh

    tmux new-window -t "$session_name":2 -c "$session_path" -n lf "source /root/.zshrc && lf; exec zsh"
    tmux new-window -t "$session_name":3 -c "$session_path" -n nvim "source /root/.zshrc; echo 'Press Enter to start build...'; read; (cd $session_path/src/Nordic/Nordic.WebApi && dotnet build); nvim .; exec zsh"
    tmux new-window -t "$session_name":4 -c "$session_path/src/Nordic/UI" -n frontend
    tmux new-window -t "$session_name":5 -c "$session_path/src/Nordic/Nordic.WebApi" -n backend
}

create_nordic_sessions() {
    session_prefix="$1"  
    base_dir="$2"  

    for folder in "$base_dir"/*; do
        if [ -d "$folder" ]; then  
            folder_name=$(basename "$folder")  
            session_name="${session_prefix}-$folder_name"  
            
            create_nordic_session "$session_name" "$folder"
        fi
    done
}

chmod +x /scripts/*.sh

source /scripts/create-session.sh

/scripts/create-default-sessions.sh

create_session "nis-baltic" "/home/projects/nisportal/baltic"

create_sessions "nis-panoramica" "/home/projects/nisportal/panoramica"
create_nordic_sessions "nis-platform" "/home/projects/nisportal/platform" 

cd /home/projects/nisportal/baltic

chmod +x ./install.sh
./install.sh

/scripts/run.sh
