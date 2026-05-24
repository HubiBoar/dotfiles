#sudo chown -R "$(id -u):$(id -g)" ./new-profiles/state

eval "$(ssh-agent -s)"
ssh-add -D
ssh-add ~/.ssh/id_ed25519_bsureas
ssh-add -l

export DEV_USER=$(id -un)
export DEV_UID=$(id -u)
export DEV_GID=$(id -g)

docker compose run --rm --build identity 
