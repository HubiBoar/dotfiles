#!/bin/bash

chmod +x /scripts/*.sh

source /scripts/create-session.sh

/scripts/create-default-sessions.sh
/scripts/create-bsure-sessions.sh

/scripts/switch-git-email.sh "hubert.dzikuc@angrynerds.pl" "/home/projects/bsure"

/scripts/run.sh
