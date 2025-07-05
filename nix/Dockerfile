FROM nixos/nix

ENTRYPOINT /bin/sh -c "cd /root/.config/nix/nvim-flake; nix profile install .; nix profile upgrade nvim-flake; tmux -u" 
