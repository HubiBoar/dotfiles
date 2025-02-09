export PROFILE=$1

docker compose -f ./docker/docker-compose.yml run --rm $PROFILE

