#!/bin/bash

chmod +x /scripts/*.sh

source /scripts/create-session.sh

/scripts/create-default-session.sh
/scripts/run.sh
