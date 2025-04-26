PROFILE=nis docker compose build base || exit 1
PROFILE=nis docker compose build nis || exit 1
PROFILE=nis docker compose run --rm nis
