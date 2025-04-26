PROFILE=go docker compose build base || exit 1
PROFILE=go docker compose build go || exit 1
PROFILE=go docker compose run --rm go
