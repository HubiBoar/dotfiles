profile=$1

docker compose --profile $profile start && docker compose --profile $profile exec -ti -w /home cde-$profile zsh
