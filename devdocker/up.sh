profile=$1

docker compose --profile $profile up -d && docker logs cde-$profile --follow
