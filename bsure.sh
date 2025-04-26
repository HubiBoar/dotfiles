PROFILE=bsure docker compose build base || exit 1
PROFILE=bsure docker compose build bsure || exit 1
PROFILE=bsure docker compose run --rm bsure
