#!/bin/bash

chmod +x /scripts/helper.sh
chmod +x /scripts/run.sh

source /scripts/helper.sh

create_session "nis-baltic" "/home/projects/nisportal/baltic"

create_sessions "nis-panoramica" "/home/projects/nisportal/panoramica"
create_sessions "nis-platform" "/home/projects/nisportal/platform" 

cd /home/projects/nisportal/baltic

chmod +x ./install.sh
./install.sh

/scripts/run.sh
