eval "$(ssh-agent -s)"

#export UID=$(id -u)
#export GID=$(id -g)

PROFILE=bsure docker compose build base || exit 1
PROFILE=bsure docker compose build bsure || exit 1
PROFILE=bsure docker compose run --rm bsure
