export PROFILE=$1

docker compose --profile $PROFILE up -d  && docker logs cde-$PROFILE --follow
