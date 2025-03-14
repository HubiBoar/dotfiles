#!/bin/bash

chmod -R 400 /root/.ssh

tmux -u attach-session -t projects \; select-window -t projects:1
