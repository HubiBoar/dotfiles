#!/usr/bin/env bash
set -euo pipefail

#sudo chown -R "$(id -u):$(id -g)" ./new-profiles/state

# Setting dedicated ssh agent
xhost +local:

KEY="$HOME/.ssh/id_ed25519_bsureas"
AGENT_DIR="$HOME/.cache/cde-ssh-agent"
AGENT_SOCK="$AGENT_DIR/ssh-agent.sock"
AGENT_ENV="$AGENT_DIR/agent.env"

mkdir -p "$AGENT_DIR"
chmod 700 "$AGENT_DIR"

agent_alive=false

if [ -S "$AGENT_SOCK" ]; then
  if SSH_AUTH_SOCK="$AGENT_SOCK" ssh-add -l >/dev/null 2>&1; then
    agent_alive=true
  fi
fi

if [ "$agent_alive" = false ]; then
  rm -f "$AGENT_SOCK" "$AGENT_ENV"

  ssh-agent -a "$AGENT_SOCK" > "$AGENT_ENV"
  # shellcheck disable=SC1090
  source "$AGENT_ENV"

  ssh-add "$KEY"
else
  export SSH_AUTH_SOCK="$AGENT_SOCK"
fi

export DEV_USER=$(id -un)
export DEV_UID=$(id -u)
export DEV_GID=$(id -g)

mkdir -p ./base/state/.config/gh

#sudo chown -R ${DEV_UID}:${DEV_GID} \
#  ./base/state/.config \
#  ./base/state/.local/share/nvim \
#  ./base/root/.config

docker compose run --rm --build identity 
