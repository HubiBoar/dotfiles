#!/bin/bash

create_session() {
    session_name=$1
    session_path=$2
    tmux new-session -d -s "$session_name" -c "$session_path" -n zsh "echo 'Press Enter...'; read; source ~/.zshrc; exec zsh"

    tmux new-window -t "$session_name":2 -c "$session_path" -n lf "echo 'Press Enter...'; read; source ~/.zshrc; lf; exec zsh"
    tmux new-window -t "$session_name":3 -c "$session_path" -n nvim "echo 'Press Enter...'; read; source ~/.zshrc; nvim .; exec zsh"
}

create_sessions() {
    session_prefix="$1"  
    base_dir="$2"  

    for folder in "$base_dir"/*; do
        if [ -d "$folder" ]; then  
            folder_name=$(basename "$folder")  
            session_name="${session_prefix}-$folder_name"  
            
            create_session "$session_name" "$folder"
        fi
    done
}
