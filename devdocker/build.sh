export PROFILE=$1

docker compose --profile $PROFILE build
