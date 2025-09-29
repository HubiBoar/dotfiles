export PROFILE=dotnet

chmod +x base.sh

./base.sh

docker compose build base || exit 1
docker compose build dotnet || exit 1
docker compose run --rm dotnet
