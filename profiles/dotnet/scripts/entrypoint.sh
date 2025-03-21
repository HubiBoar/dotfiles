#!/bin/bash

chmod +x /scripts/helper.sh
chmod +x /scripts/run.sh

source /scripts/helper.sh

create_session "konfik" "/home/projects/hubiboar/konfik"
create_session "definit" "/home/projects/hubiboar/definit"
create_session "feature-slice" "/home/projects/hubiboar/feature-slice"

/scripts/run.sh
