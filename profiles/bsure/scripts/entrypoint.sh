#!/bin/bash

chmod +x /scripts/*.sh

source /scripts/create-session.sh

/scripts/create-default-sessions.sh
/scripts/create-bsure-sessions.sh

/scripts/run.sh
