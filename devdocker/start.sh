export PROFILE=$1

docker compose --profile $PROFILE start && docker compose --profile $PROFILE exec -ti -w /home cde-$PROFILE zsh
