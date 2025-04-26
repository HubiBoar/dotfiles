PROFILE=dotnet docker compose build base || exit 1
PROFILE=dotnet docker compose build dotnet || exit 1
PROFILE=dotnet docker compose run --rm dotnet
